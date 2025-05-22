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

typedef enum {
  UNIT_BPS,
  UNIT_KBPS,
  UNIT_MBPS
} NetworkUnit;

static char unit_str[3][6] = {
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
};

/*********************************
 * Core Network Functions
 *********************************/

/**
 * Initialize the network struct for a given interface
 * @param net The network struct to initialize
 * @param ifname The name of the network interface
 * @return 0 on success, -1 on failure
 */
static inline int network_init(struct network *net, const char *ifname);

/**
 * Update the network struct with current data
 * @param net The network struct to update
 * @return void
 */
static inline void network_update(struct network *net);

/**
 * Calculate the network metrics from raw byte counts
 * @param delta_bytes The number of bytes transferred
 * @param unit Pointer to store the unit of the network data
 * @param value Pointer to store the value of the network data
 * @return void
 */
static inline void calculate_network_metrics(double delta_bytes, NetworkUnit *unit, int *value);

/**
 * Get the network data for the given network row
 * @param net_row The network row to get data for
 * @param data Pointer to the network data structure to fill
 * @return 0 on success, -1 on failure
 */
static inline int ifdata(uint32_t net_row, struct ifmibdata *data);

/**
 * Signal handler for clean shutdown
 * @param signal The signal number
 * @return void
 */
static void cleanup_and_exit(int signal);

#endif /* NETWORK_LOAD_H */
