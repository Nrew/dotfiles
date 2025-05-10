#include "network_load.h"

/*********************************
 * Core Network Functions
 *********************************/

static inline int ifdata(uint32_t net_row, struct ifmibdata *data) {
    if (!data) return -1;
    
    static const size_t size = sizeof(struct ifmibdata);
    static int32_t data_option[] = {
        CTL_NET, PF_LINK, NETLINK_GENERIC,
        IFMIB_IFDATA, 0, IFDATA_GENERAL
    };
    data_option[4] = net_row;
    
    return sysctl(data_option, 6, data, &size, NULL, 0);
}

static inline int network_init(struct network *net, const char *ifname) {
    if (!net || !ifname) return -1;
    
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
    
    for (int i = 0; i < interface_count; i++) {
        if (ifdata(i, &net->data) != 0) continue;

        if (strcmp(net->data.ifmd_name, ifname) == 0) {
            net->row = i;
            return 0;
        }
    }

    return -1;
}

static inline void calculate_network_metrics(double delta_bytes, NetworkUnit *unit, double *value) {
    if (delta_bytes > 0) {
        double exponent = log10(delta_bytes);
        if (exponent < 3) {
            *unit = UNIT_BPS;
            *value = delta_bytes;
        } else if (exponent < 6) {
            *unit = UNIT_KBPS;
            *value = delta_bytes / 1000.0;
        } else {
            *unit = UNIT_MBPS;
            *value = delta_bytes / 1000000.0;
        }
    } else {
        *unit = UNIT_BPS;
        *value = 0;
    }
}

static inline void network_update(struct network *net) {
  if (!net) return;

  gettimeofday(&net->tv_n, NULL);
  timersub(&net->tv_n, &net->tv_nm1, &net->tv_delta);
  net->tv_nm1 = net->tv_n;

  uint64_t ibytes_nm1 = net->data.ifmd_data.ifi_ibytes;
  uint64_t obytes_nm1 = net->data.ifmd_data.ifi_obytes;

  if (ifdata(net->row, &net->data) != 0) return;

  double delta_ibytes = (double)(net->data.ifmd_data.ifi_ibytes - ibytes_nm1) / time_scale;
  double delta_obytes = (double)(net->data.ifmd_data.ifi_obytes - obytes_nm1) / time_scale;

  calculate_network_metrics(delta_ibytes, &net->down_unit, &net->down);
  calculate_network_metrics(delta_obytes, &net->up_unit, &net->up);
}

int main(int argc, char **argv) {

  if (argc < 4) {
    printf("Usage: %s \"<interface>\" \"<event-name>\" \"<event_freq>\"\n", argv[0]);
    return EXIT_FAILURE;
  }

  char *endptr;
  errno = 0;
  float update_freq = strtof(argv[3], &endptr);

  if (errno != 0 || *endptr != '\0') {
    printf("Invalid update frequency\n");
    return EXIT_FAILURE;
  }

  alarm(0);

  char event_message[EVENT_MESSAGE_SIZE];
  if (snprintf(event_message, EVENT_MESSAGE_SIZE, "--add event '%s'", argv[2]) >= EVENT_MESSAGE_SIZE 0) {
    printf("Event name too long\n");
    return EXIT_FAILURE;
  }

  sketchybar(event_message);

  // Initialize network monitoring
  struct network network;
  if (network_init(&network, argv[1]) != 0) {
    printf("Failed to initialize network monitoring for interface: %s\n", argv[1]);
    return EXIT_FAILURE;
  }
  char trigger_message[EVENT_MESSAGE_SIZE];
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);

  if (!timer) {
    printf("Failed to create timer\n");
    return EXIT_FAILURE;
  }

  uint64_t interval = update_freq * NSEC_PER_SEC;
  dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 0), interval, interval / 10);

  dispatch_source_set_event_handler(timer, ^{
    network_update(&network);

    if (snprintf(trigger_message, EVENT_MESSAGE_SIZE,
                "--trigger '%s' upload='%03d%s' download='%03d%s'",
                argv[2], network.up, unit_str[network.up_unit],
                network.down, unit_str[network.down_unit]) < EVENT_MESSAGE_SIZE) {
        sketchybar(trigger_message);
    }
  });

  dispatch_resume(timer);

  dispatch_main();
  return 0;
}