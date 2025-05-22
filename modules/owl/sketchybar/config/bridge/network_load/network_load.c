#include "network_load.h"

/*********************************
 * Core Network Functions
 *********************************/

static inline int ifdata(uint32_t net_row, struct ifmibdata *data) {
    if (!data) {
        return -1;
    }
    
    int32_t data_option[] = {
        CTL_NET, PF_LINK, NETLINK_GENERIC,
        IFMIB_IFDATA, 0, IFDATA_GENERAL
    };
    data_option[4] = net_row;

    size_t size = sizeof(struct ifmibdata);
    int result = sysctl(data_option, 6, data, &size, NULL, 0);
    
    if (result != 0) {
        memset(data, 0, sizeof(struct ifmibdata));
    }
    
    return result;
}

static inline int network_init(struct network *net, const char *ifname) {
    if (!net || !ifname || strlen(ifname) == 0) {
        return -1;
    }
    
    memset(net, 0, sizeof(struct network));
    
    static int count_option[] = {
        CTL_NET, PF_LINK, NETLINK_GENERIC,
        IFMIB_SYSTEM, IFMIB_IFCOUNT
    };

    uint32_t interface_count = 0;
    size_t size = sizeof(uint32_t);
    
    if (sysctl(count_option, 5, &interface_count, &size, NULL, 0) != 0) {
        return -1;
    }
    
    // Bounds check for interface count
    if (interface_count == 0 || interface_count > MAX_INTERFACES) {
        return -1;
    }
    
    for (uint32_t i = 1; i < interface_count; i++) {
        if (ifdata(i, &net->data) != 0) {
            continue;
        }

        // Ensure null termination of interface name
        net->data.ifmd_name[IFNAMSIZ - 1] = '\0';
        
        if (strcmp(net->data.ifmd_name, ifname) == 0) {
            net->row = i;
            if (gettimeofday(&net->tv_nm1, NULL) != 0) {
                return -1;
            }
            return 0;
        }
    }

    return -1;
}

static inline void calculate_network_metrics(double delta_bytes, NetworkUnit *unit, int *value) {
    if (!unit || !value) {
        return;
    }
    
    double double_value = 0;
    
    if (delta_bytes > 0 && isfinite(delta_bytes)) {
        double exponent = log10(delta_bytes);
        if (exponent < 3) {
            *unit = UNIT_BPS;
            double_value = delta_bytes;
        } else if (exponent < 6) {
            *unit = UNIT_KBPS;
            double_value = delta_bytes / 1000.0;
        } else {
            *unit = UNIT_MBPS;
            double_value = delta_bytes / 1000000.0;
        }
    } else {
        *unit = UNIT_BPS;
        double_value = 0;
    }
    
    // Clamp value to reasonable range
    if (double_value > MAX_DISPLAY_VALUE) {
        double_value = MAX_DISPLAY_VALUE;
    }
    
    *value = (int)round(double_value);
}

static inline void network_update(struct network *net) {
    if (!net) {
        return;
    }

    if (gettimeofday(&net->tv_n, NULL) != 0) {
        return;
    }
    
    timersub(&net->tv_n, &net->tv_nm1, &net->tv_delta);
    net->tv_nm1 = net->tv_n;

    uint64_t ibytes_nm1 = net->data.ifmd_data.ifi_ibytes;
    uint64_t obytes_nm1 = net->data.ifmd_data.ifi_obytes;

    if (ifdata(net->row, &net->data) != 0) {
        return;
    }

    double time_scale = (net->tv_delta.tv_sec + MIN_TIME_SCALE * net->tv_delta.tv_usec);
    
    // Validate time scale to prevent division by zero or unrealistic values
    if (time_scale < MIN_TIME_SCALE || time_scale > MAX_TIME_SCALE) {
        return;
    }

    // Check for counter wraparound or invalid data
    if (net->data.ifmd_data.ifi_ibytes < ibytes_nm1 || 
        net->data.ifmd_data.ifi_obytes < obytes_nm1) {
        // Counter wrapped around, skip this update
        return;
    }

    double delta_ibytes = (double)(net->data.ifmd_data.ifi_ibytes - ibytes_nm1) / time_scale;
    double delta_obytes = (double)(net->data.ifmd_data.ifi_obytes - obytes_nm1) / time_scale;

    calculate_network_metrics(delta_ibytes, &net->down_unit, &net->down);
    calculate_network_metrics(delta_obytes, &net->up_unit, &net->up);
}

static void cleanup_and_exit(int signal) {
    (void)signal; // Suppress unused parameter warning
    exit(EXIT_SUCCESS);
}

int main(int argc, char **argv) {
    if (argc < 4) {
        fprintf(stderr, "Usage: %s \"<interface>\" \"<event-name>\" \"<event_freq>\"\n", argv[0]);
        return EXIT_FAILURE;
    }

    // Validate interface name length
    if (strlen(argv[1]) >= IFNAMSIZ) {
        fprintf(stderr, "Interface name too long: %s\n", argv[1]);
        return EXIT_FAILURE;
    }

    // Parse and validate update frequency
    char *endptr;
    errno = 0;
    float update_freq = strtof(argv[3], &endptr);

    if (errno != 0 || *endptr != '\0' || update_freq <= 0 || update_freq > MAX_UPDATE_FREQ) {
        fprintf(stderr, "Invalid update frequency: %s (must be between 0 and %d)\n", 
                argv[3], MAX_UPDATE_FREQ);
        return EXIT_FAILURE;
    }

    // Validate event name length
    if (strlen(argv[2]) >= MAX_EVENT_NAME_LENGTH) {
        fprintf(stderr, "Event name too long: %s\n", argv[2]);
        return EXIT_FAILURE;
    }

    // Set up signal handlers for clean exit
    signal(SIGTERM, cleanup_and_exit);
    signal(SIGINT, cleanup_and_exit);
    
    // Clear any existing alarms
    alarm(0);

    // Create and send the add event message
    char event_message[EVENT_MESSAGE_SIZE];
    int written = snprintf(event_message, EVENT_MESSAGE_SIZE, "--add event '%s'", argv[2]);
    
    if (written >= EVENT_MESSAGE_SIZE || written < 0) {
        fprintf(stderr, "Event name too long: %s\n", argv[2]);
        return EXIT_FAILURE;
    }

    sketchybar(event_message);

    // Initialize network monitoring
    __block struct network network;
    if (network_init(&network, argv[1]) != 0) {
        fprintf(stderr, "Failed to initialize network monitoring for interface: %s\n", argv[1]);
        return EXIT_FAILURE;
    }
    
    const char* event_name = argv[2];

    // Create dispatch queue and timer
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);

    if (!timer) {
        fprintf(stderr, "Failed to create timer\n");
        return EXIT_FAILURE;
    }

    uint64_t interval = (uint64_t)(update_freq * NSEC_PER_SEC);
    uint64_t leeway = interval / 10; // 10% leeway for system optimization
    
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 0), interval, leeway);

    dispatch_source_set_event_handler(timer, ^{
        network_update(&network);
        
        char trigger_message[EVENT_MESSAGE_SIZE];
        int msg_written = snprintf(trigger_message, EVENT_MESSAGE_SIZE,
                    "--trigger '%s' upload='%03d%s' download='%03d%s'",
                    event_name, 
                    network.up, unit_str[network.up_unit],
                    network.down, unit_str[network.down_unit]);
                    
        if (msg_written > 0 && msg_written < EVENT_MESSAGE_SIZE) {
            sketchybar(trigger_message);
        }
    });

    // Set up cancellation handler
    dispatch_source_set_cancel_handler(timer, ^{
        dispatch_release(timer);
    });

    dispatch_resume(timer);
    dispatch_main();
    
    return EXIT_SUCCESS;
}
