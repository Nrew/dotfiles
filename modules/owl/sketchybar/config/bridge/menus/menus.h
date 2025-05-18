#ifndef MENUS_H
#define MENUS_H

#include <Carbon/Carbon.h>
#include <dispatch/dispatch.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <limits.h>

/*********************************
 * Constants and Types
 *********************************/
#define MAX_BUFFER_SIZE 512
#define MENU_POSITION_TOLERANCE 10.0
#define CLICK_DELAY_MICROSECONDS 150000

typedef enum {
    MENU_SUCCESS = 0,
    MENU_ERROR_INIT_FAILED,
    MENU_ERROR_NOT_FOUND,
    MENU_ERROR_INVALID_PARAM,
    MENU_ERROR_MEMORY,
    MENU_ERROR_ACCESSIBILITY
} MenuError;

/*********************************
 * Core Accessibility Functions
 *********************************/

/**
 * Initialize accessibility features and check permissions
 * @return MENU_SUCCESS if successful, error code otherwise
 */
MenuError ax_init(void);

/**
 * Get the frontmost application
 * @return AXUIElementRef of the front application, or NULL on failure
 */
AXUIElementRef ax_get_front_app(void);

/*********************************
 * Menu Bar Operations
 *********************************/

/**
 * Print all menu options for the given application
 * @param app The application reference
 * @return MENU_SUCCESS if successful, error code otherwise
 */
MenuError ax_print_menu_options(AXUIElementRef app);

/**
 * Select a menu option by index
 * @param app The application reference
 * @param id The index of the menu item
 * @return MENU_SUCCESS if successful, error code otherwise
 */
MenuError ax_select_menu_option(AXUIElementRef app, int id);

/**
 * Select a menu extra by its alias
 * @param alias The alias of the menu extra
 * @return MENU_SUCCESS if successful, error code otherwise
 */
MenuError ax_select_menu_extra(const char* alias);

/*********************************
 * Error Handling
 *********************************/

/**
 * Convert MenuError to string description
 * @param error The error code
 * @return String description of the error
 */
const char* menu_error_to_string(MenuError error);

/*********************************
 * Private Helper Functions
 *********************************/
/**
 * Perform a click action on the given element
 * @param element The element to click
 * @param completion The completion block to call after the click
 * @return void
 */
static AXError ax_get_attribute(AXUIElementRef element, CFStringRef attribute, CFTypeRef *value);

/**
 * Perform a click action on the given element
 * @param element The element to click
 * @param completion The completion block to call after the click
 * @return void
 */
static AXError ax_get_menubar_children(AXUIElementRef app, CFArrayRef *children);

#endif /* MENUS_H */
