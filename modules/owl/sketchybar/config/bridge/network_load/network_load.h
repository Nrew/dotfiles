#include "../sketchybar.h"
#include <math.h>
#include <net/if.h>
#include <net/if_mib.h>
#include <stdio.h>
#include <string.h>
#include <sys/select.h>
#include <sys/sysctl.h>
#include <stdlib.h>
#include <unistd.h>

/*********************************
 * Constants and Types
 *********************************/
#define EVENT_MESSAGE_SIZE 512
#define MIN_TIME_SCALE 1e-6 
#define MAX_TIME_SCALE 1e2     

typedef enum {
  UNIT_BPS,
  UNIT_KBPS,
  UNIT_MBPS
} NetworkUnit;

static char unit_str[3][6] = {
  "Bps",
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
 * Initialize the network struct
 * @param net The network struct to initialize
 * @param ifname The name of the network interface
 * @return void
 */
static inline int network_init(struct network *net, const char *ifname);

/**
 * Update the network struct
 * @param net The network struct to update
 * @return void
 */
static inline void network_update(struct network *net);

/**
 * Calculate the network metrics
 * @param delta_bytes The number of bytes transferred
 * @param unit The unit of the network data
 * @param value The value of the network data
 * @return void
 */
static inline void calculate_network_metrics(double delta_bytes, NetworkUnit *unit, double *value);

/**
 * Get the network data for the given network row
 * @param net_row The network row to get data for
 * @param data The network data to fill
 * @return a status code
 */
static inline int ifdata(uint32_t net_row, struct ifmibdata *data);

#endif /* NETWORK_LOAD_H */