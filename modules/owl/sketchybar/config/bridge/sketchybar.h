#ifndef SKETCHYBAR_H
#define SKETCHYBAR_H

#include <bootstrap.h>
#include <mach/arm/kern_return.h>
#include <mach/mach.h>
#include <mach/mach_port.h>
#include <mach/message.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <stdint.h>

/*********************************
 * Types and Constants
 *********************************/
#define SKETCHYBAR_DEFAULT_NAME "sketchybar"
#define SKETCHYBAR_SERVICE_PREFIX "git.felix."
#define INITIAL_PORT_VALUE 0
#define MAX_MESSAGE_SIZE 4096
#define MAX_RETRIES 3
#define SERVICE_NAME_MAX_LENGTH 256

typedef char* env;
typedef void (*mach_handler)(env env);

/*********************************
 * Message Structures
 *********************************/
struct mach_message {
    mach_msg_header_t header;
    mach_msg_size_t msgh_descriptor_count;
    mach_msg_ool_descriptor_t descriptor;
};

struct mach_buffer {
    struct mach_message message;
    mach_msg_trailer_t trailer;
};

/*********************************
 * Global State
 *********************************/
static volatile mach_port_t g_mach_port = INITIAL_PORT_VALUE;
static pthread_mutex_t g_port_mutex = PTHREAD_MUTEX_INITIALIZER;
static pthread_once_t g_init_once = PTHREAD_ONCE_INIT;

static void init_mach_port(void) {
    g_mach_port = mach_get_bs_port();
}

// In sketchybar function:
pthread_once(&g_init_once, init_mach_port);

/*********************************
 * Function Declarations
 *********************************/

/**
 * Get the bootstrap port for sketchybar with error handling
 * @return Mach port or 0 on failure
 */
static inline mach_port_t mach_get_bs_port(void);

/**
 * Send a message through the mach port with retry logic
 * @param port Destination port
 * @param message Message content (must not be NULL)
 * @param len Message length (must be > 0)
 * @return true on success, false on failure
 */
static inline bool mach_send_message(mach_port_t port, char* message, uint32_t len);

/**
 * Format a message for sketchybar protocol with bounds checking
 * @param message Input message (must not be NULL)
 * @param formatted_message Output buffer for formatted message (must not be NULL)
 * @param buffer_size Size of output buffer
 * @return Length of formatted message, 0 on failure
 */
static inline uint32_t format_message(const char* message, char* formatted_message, size_t buffer_size);

/**
 * Send a command to sketchybar with thread safety
 * @param message Command to send (must not be NULL)
 */
static inline void sketchybar(char* message);

/**
 * Validate service name for safety
 * @param name Service name to validate
 * @return true if valid, false otherwise
 */
static inline bool validate_service_name(const char* name);

/*********************************
 * Implementation
 *********************************/

static inline bool validate_service_name(const char* name) {
    if (!name) return false;
    
    size_t len = strlen(name);
    if (len == 0 || len >= SERVICE_NAME_MAX_LENGTH) return false;
    
    // Check for valid characters (alphanumeric, underscore, hyphen, dot)
    for (size_t i = 0; i < len; i++) {
        char c = name[i];
        if (!((c >= 'a' && c <= 'z') || 
              (c >= 'A' && c <= 'Z') || 
              (c >= '0' && c <= '9') || 
              c == '_' || c == '-' || c == '.')) {
            return false;
        }
    }
    
    return true;
}

static inline mach_port_t mach_get_bs_port(void) {
    mach_port_name_t task = mach_task_self();
    mach_port_t bs_port;

    if (task_get_special_port(task, TASK_BOOTSTRAP_PORT, &bs_port) != KERN_SUCCESS) {
        return 0;
    }

    const char* name = getenv("BAR_NAME");
    if (!name) {
        name = SKETCHYBAR_DEFAULT_NAME;
    }
    
    if (!validate_service_name(name)) {
        fprintf(stderr, "Error: Invalid service name: %s\n", name);
        return 0;
    }

    size_t prefix_len = strlen(SKETCHYBAR_SERVICE_PREFIX);
    size_t name_len = strlen(name);
    size_t lookup_len = prefix_len + name_len + 1;
    
    char* buffer = malloc(lookup_len);
    if (!buffer) {
        fprintf(stderr, "Error: Memory allocation failed\n");
        return 0;
    }

    int written = snprintf(buffer, lookup_len, "%s%s", SKETCHYBAR_SERVICE_PREFIX, name);
    if (written < 0 || (size_t)written >= lookup_len) {
        free(buffer);
        return 0;
    }

    mach_port_t port;
    kern_return_t result = bootstrap_look_up(bs_port, buffer, &port);
    free(buffer);

    return (result == KERN_SUCCESS) ? port : 0;
}

static inline bool mach_send_message(mach_port_t port, char* message, uint32_t len) {
    if (!message || !port || len == 0 || len > MAX_MESSAGE_SIZE) {
        return false;
    }

    struct mach_message msg = {0};
    msg.header.msgh_remote_port = port;
    msg.header.msgh_local_port = MACH_PORT_NULL;
    msg.header.msgh_id = 0;
    msg.header.msgh_bits = MACH_MSGH_BITS_SET(
        MACH_MSG_TYPE_COPY_SEND,
        MACH_MSG_TYPE_MAKE_SEND,
        0,
        MACH_MSGH_BITS_COMPLEX
    );

    msg.header.msgh_size = sizeof(struct mach_message);
    msg.msgh_descriptor_count = 1;
    msg.descriptor.address = message;
    msg.descriptor.size = len * sizeof(char);
    msg.descriptor.copy = MACH_MSG_VIRTUAL_COPY;
    msg.descriptor.deallocate = false;
    msg.descriptor.type = MACH_MSG_OOL_DESCRIPTOR;

    kern_return_t result = mach_msg(
        &msg.header,
        MACH_SEND_MSG,
        sizeof(struct mach_message),
        0,
        MACH_PORT_NULL,
        MACH_MSG_TIMEOUT_NONE,
        MACH_PORT_NULL
    );

    return result == KERN_SUCCESS;
}

static inline uint32_t format_message(const char* message, char* formatted_message, size_t buffer_size) {
    if (!message || !formatted_message || buffer_size == 0) {
        return 0;
    }

    char outer_quote = 0;
    uint32_t caret = 0;
    size_t message_length = strlen(message);
    
    // Ensure we don't exceed buffer size
    size_t max_process = (buffer_size > message_length + 1) ? message_length : buffer_size - 1;

    for (size_t i = 0; i < max_process && caret < buffer_size - 1; ++i) {
        if (message[i] == '"' || message[i] == '\'') {
            if (outer_quote && outer_quote == message[i]) {
                outer_quote = 0;
            } else if (!outer_quote) {
                outer_quote = message[i];
            }
            continue;
        }

        formatted_message[caret] = message[i];
        if (message[i] == ' ' && !outer_quote) {
            formatted_message[caret] = '\0';
        }
        caret++;
    }

    // Ensure null termination
    if (caret > 0 && caret < buffer_size && 
        formatted_message[caret - 1] == '\0' && caret > 1 &&
        formatted_message[caret - 2] == '\0') {
        caret--;
    }
    
    if (caret < buffer_size) {
        formatted_message[caret] = '\0';
        return caret + 1;
    }
    
    formatted_message[buffer_size - 1] = '\0';
    return buffer_size;
}

static inline void sketchybar(char* message) {
    if (!message) {
        return;
    }

    size_t msg_len = strlen(message);
    if (msg_len == 0 || msg_len > MAX_MESSAGE_SIZE) {
        return;
    }

    // Allocate buffer for formatted message with safety margin
    size_t buffer_size = msg_len + 2;
    char* formatted_message = malloc(buffer_size);
    if (!formatted_message) {
        fprintf(stderr, "Error: Memory allocation failed for message formatting\n");
        return;
    }

    uint32_t length = format_message(message, formatted_message, buffer_size);
    if (length == 0) {
        free(formatted_message);
        return;
    }

    // Thread-safe port management
    pthread_mutex_lock(&g_port_mutex);
    
    // Get or create mach port if needed
    if (!g_mach_port) {
        g_mach_port = mach_get_bs_port();
    }

    mach_port_t current_port = g_mach_port;
    pthread_mutex_unlock(&g_port_mutex);

    // Try to send message with retry logic
    bool success = false;
    for (int retry = 0; retry < MAX_RETRIES && !success; retry++) {
        if (current_port && mach_send_message(current_port, formatted_message, length)) {
            success = true;
        } else {
            // Port might be stale, try to refresh
            pthread_mutex_lock(&g_port_mutex);
            g_mach_port = mach_get_bs_port();
            current_port = g_mach_port;
            pthread_mutex_unlock(&g_port_mutex);
        }
    }

    if (!success) {
        // Silently fail - sketchybar might not be running
        // Don't call exit() as it's too aggressive for a library function
    }

    free(formatted_message);
}

#endif /* SKETCHYBAR_H */
