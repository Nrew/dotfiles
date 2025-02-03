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

/*********************************
 * Types and Constants
 *********************************/
#define SKETCHYBAR_DEFAULT_NAME "sketchybar"
#define SKETCHYBAR_SERVICE_PREFIX "git.felix."
#define INITIAL_PORT_VALUE 0
#define MAX_MESSAGE_SIZE 4096

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
static mach_port_t g_mach_port = INITIAL_PORT_VALUE;

/*********************************
 * Function Declarations
 *********************************/

/**
 * Get the bootstrap port for sketchybar
 * @return Mach port or 0 on failure
 */
static inline mach_port_t mach_get_bs_port(void);

/**
 * Send a message through the mach port
 * @param port Destination port
 * @param message Message content
 * @param len Message length
 * @return true on success, false on failure
 */
static inline bool mach_send_message(mach_port_t port, char* message, uint32_t len);

/**
 * Format a message for sketchybar protocol
 * @param message Input message
 * @param formatted_message Output buffer for formatted message
 * @return Length of formatted message
 */
static inline uint32_t format_message(const char* message, char* formatted_message);

/**
 * Send a command to sketchybar
 * @param message Command to send
 */
static inline void sketchybar(char* message);

/*********************************
 * Implementation
 *********************************/

static inline mach_port_t mach_get_bs_port(void) {
    mach_port_name_t task = mach_task_self();
    mach_port_t bs_port;

    if (task_get_special_port(task, TASK_BOOTSTRAP_PORT, &bs_port) != KERN_SUCCESS) {
        return 0;
    }

    const char* name = getenv("BAR_NAME");
    if (!name) name = SKETCHYBAR_DEFAULT_NAME;

    size_t lookup_len = strlen(SKETCHYBAR_SERVICE_PREFIX) + strlen(name) + 1;
    char* buffer = malloc(lookup_len);
    
    if (!buffer) return 0;

    snprintf(buffer, lookup_len, "%s%s", SKETCHYBAR_SERVICE_PREFIX, name);

    mach_port_t port;
    kern_return_t result = bootstrap_look_up(bs_port, buffer, &port);
    free(buffer);

    return (result == KERN_SUCCESS) ? port : 0;
}

static inline bool mach_send_message(mach_port_t port, char* message, uint32_t len) {
    if (!message || !port || len == 0) return false;

    struct mach_message msg = {0};
    msg.header.msgh_remote_port = port;
    msg.header.msgh_local_port = 0;
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

    return mach_msg(
        &msg.header,
        MACH_SEND_MSG,
        sizeof(struct mach_message),
        0,
        MACH_PORT_NULL,
        MACH_MSG_TIMEOUT_NONE,
        MACH_PORT_NULL
    ) == KERN_SUCCESS;
}

static inline uint32_t format_message(const char* message, char* formatted_message) {
    if (!message || !formatted_message) return 0;

    char outer_quote = 0;
    uint32_t caret = 0;
    size_t message_length = strlen(message) + 1;
    
    if (message_length > MAX_MESSAGE_SIZE) {
        message_length = MAX_MESSAGE_SIZE;
    }

    for (size_t i = 0; i < message_length; ++i) {
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

    if (caret > 0 && formatted_message[caret] == '\0' &&
        formatted_message[caret - 1] == '\0') {
        caret--;
    }
    formatted_message[caret] = '\0';
    return caret + 1;
}

static inline void sketchybar(char* message) {
    if (!message) return;

    size_t msg_len = strlen(message);
    if (msg_len == 0) return;

    // Allocate buffer for formatted message
    char* formatted_message = malloc(msg_len + 2);
    if (!formatted_message) return;

    uint32_t length = format_message(message, formatted_message);
    if (!length) {
        free(formatted_message);
        return;
    }

    // Get or create mach port if needed
    if (!g_mach_port) {
        g_mach_port = mach_get_bs_port();
    }

    // Try to send message, retry once if failed
    if (!mach_send_message(g_mach_port, formatted_message, length)) {
        g_mach_port = mach_get_bs_port();
        if (!mach_send_message(g_mach_port, formatted_message, length)) {
            free(formatted_message);
            exit(0);  // No sketchybar instance running
        }
    }

    free(formatted_message);
}

#endif /* SKETCHYBAR_H */