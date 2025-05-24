#ifndef NETWORK_LOAD_H
#define NETWORK_LOAD_H

#include <math.h>
#include <net/if.h>
#include <net/if_mib.h>
#include <stdio.h>
#include <string.h>
#include <sys/sysctl.h>
#include <sys/time.h>
#include <stdlib.h>
#include <unistd.h>
#include <dispatch/dispatch.h>
#include <errno.h>
#include <signal.h>
#include <stdbool.h>
#include <stdint.h>
#include "../sketchybar.h"

/*********************************
 * Constants and Types
 *********************************/
#define EVENT_MESSAGE_SIZE 512
#define MAX_EVENT_NAME_LENGTH 256
#define MIN_TIME_SCALE 1e-6 
#define MAX_TIME_SCALE 1e2
#define MAX_UPDATE_FREQ 60
#define MAX_INTERFACES 1024
#define MAX_DISPLAY_VALUE 999
#define NETWORK_ERROR_THRESHOLD 5
#define BYTES_PER_KILOBYTE 1000.0
#define BYTES_PER_MEGABYTE 1000000.0

typedef enum {
  UNIT_BPS = 0,
  UNIT_KBPS,
  UNIT_MBPS,
  UNIT_MAX  // Sentinel value for bounds checking
} NetworkUnit;

// Use const array for better performance and safety
static const char* const unit_str[UNIT_MAX] = {
  "Bps ",
  "KBps",
  "MBps",
};

struct network {
  uint32_t row;
  struct ifmibdata data;
  struct timeval tv_nm1, tv_n, tv_delta;
  
  int up;
  int down;
  NetworkUnit up_unit, down_unit;
  
  // Error tracking
  unsigned int error_count;
  bool initialized;
};

/*********************************
 * Core Network Functions
 *********************************/

/**
 * Initialize the network struct for a given interface
 * @param net The network struct to initialize (must not be NULL)
 * @param ifname The name of the network interface (must not be NULL or empty)
 * @return 0 on success, -1 on failure
 */
static inline int network_init(struct network *net, const char *ifname);

/**
 * Update the network struct with current data
 * Includes error recovery and bounds checking
 * @param net The network struct to update (must not be NULL)
 */
static inline void network_update(struct network *net);

/**
 * Calculate the network metrics from raw byte counts
 * Includes overflow protection and unit scaling
 * @param delta_bytes The number of bytes transferred
 * @param unit Pointer to store the unit of the network data (must not be NULL)
 * @param value Pointer to store the value of the network data (must not be NULL)
 */
static inline void calculate_network_metrics(double delta_bytes, NetworkUnit *unit, int *value);

/**
 * Get the network data for the given network row
 * @param net_row The network row to get data for
 * @param data Pointer to the network data structure to fill (must not be NULL)
 * @return 0 on success, -1 on failure
 */
static inline int ifdata(uint32_t net_row, struct ifmibdata *data);

/**
 * Signal handler for clean shutdown
 * @param signal The signal number
 */
static void cleanup_and_exit(int signal);

/**
 * Validate network parameters before processing
 * @param net The network struct to validate
 * @return true if valid, false otherwise
 */
static inline bool validate_network_state(const struct network *net) {
    return net != NULL && 
           net->initialized && 
           net->error_count < NETWORK_ERROR_THRESHOLD &&
           net->up_unit < UNIT_MAX &&
           net->down_unit < UNIT_MAX;
}

/**
 * Reset network error state
 * @param net The network struct to reset
 */
static inline void reset_network_errors(struct network *net) {
    if (net) {
        net->error_count = 0;
    }
}

/**
 * Check if time delta is valid for calculations
 * @param tv_delta The time delta to check
 * @return true if valid, false otherwise
 */
static inline bool is_valid_time_delta(const struct timeval *tv_delta) {
    if (!tv_delta) return false;
    
    double time_scale = tv_delta->tv_sec + MIN_TIME_SCALE * tv_delta->tv_usec;
    return time_scale >= MIN_TIME_SCALE && time_scale <= MAX_TIME_SCALE;
}

#endif /* NETWORK_LOAD_H */
