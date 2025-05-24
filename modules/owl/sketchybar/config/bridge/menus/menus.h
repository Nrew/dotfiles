#ifndef MENUS_H
#define MENUS_H

#include <Carbon/Carbon.h>
#include <dispatch/dispatch.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <limits.h>
#include <math.h>

/*********************************
 * Constants and Types
 *********************************/
#define MAX_BUFFER_SIZE 512
#define MENU_POSITION_TOLERANCE 10.0
#define CLICK_DELAY_MICROSECONDS 150000
#define MAX_RETRY_ATTEMPTS 3
#define ACCESSIBILITY_TIMEOUT_SECONDS 5

typedef enum {
    MENU_SUCCESS = 0,
    MENU_ERROR_INIT_FAILED,
    MENU_ERROR_NOT_FOUND,
    MENU_ERROR_INVALID_PARAM,
    MENU_ERROR_MEMORY,
    MENU_ERROR_ACCESSIBILITY,
    MENU_ERROR_TIMEOUT,
    MENU_ERROR_PERMISSION_DENIED,
    MENU_ERROR_SYSTEM_ERROR
} MenuError;

/*********************************
 * Core Accessibility Functions
 *********************************/

/**
 * Initialize accessibility features and check permissions
 * Prompts user for accessibility permissions if needed
 * @return MENU_SUCCESS if successful, error code otherwise
 */
MenuError ax_init(void);

/**
 * Get the frontmost application with error handling
 * @return AXUIElementRef of the front application, or NULL on failure
 */
AXUIElementRef ax_get_front_app(void);

/*********************************
 * Menu Bar Operations
 *********************************/

/**
 * Print all menu options for the given application
 * Skips the application menu (index 0) and only shows user menus
 * @param app The application reference (must not be NULL)
 * @return MENU_SUCCESS if successful, error code otherwise
 */
MenuError ax_print_menu_options(AXUIElementRef app);

/**
 * Select a menu option by index with proper error handling
 * @param app The application reference (must not be NULL)
 * @param id The index of the menu item (must be >= 0)
 * @return MENU_SUCCESS if successful, error code otherwise
 */
MenuError ax_select_menu_option(AXUIElementRef app, int id);

/**
 * Select a menu extra by its alias with retry logic
 * @param alias The alias of the menu extra in format "OwnerName,WindowName" (must not be NULL)
 * @return MENU_SUCCESS if successful, error code otherwise
 */
MenuError ax_select_menu_extra(const char* alias);

/*********************************
 * Error Handling and Utilities
 *********************************/

/**
 * Convert MenuError to human-readable string description
 * @param error The error code
 * @return Constant string description of the error (never NULL)
 */
const char* menu_error_to_string(MenuError error);

/**
 * Validate that a string parameter is safe to use
 * @param str The string to validate
 * @param max_length Maximum allowed length
 * @return true if valid, false otherwise
 */
static inline bool validate_string_param(const char* str, size_t max_length) {
    return str != NULL && strlen(str) > 0 && strlen(str) < max_length;
}

/**
 * Safe string copy with bounds checking
 * @param dest Destination buffer
 * @param src Source string
 * @param dest_size Size of destination buffer
 * @return true if successful, false if truncated or failed
 */
static inline bool safe_string_copy(char* dest, const char* src, size_t dest_size) {
    if (!dest || !src || dest_size == 0) {
        return false;
    }
    
    size_t src_len = strlen(src);
    if (src_len >= dest_size) {
        return false; // Would be truncated
    }
    
    strncpy(dest, src, dest_size - 1);
    dest[dest_size - 1] = '\0';
    return true;
}

#endif /* MENUS_H */
