#include "menus.h"

/*********************************
 * Private SLS API Declarations
 *********************************/
extern int SLSMainConnectionID(void);
extern void SLSSetMenuBarVisibilityOverrideOnDisplay(int cid, int did, bool enabled);
extern void SLSSetMenuBarInsetAndAlpha(int cid, double u1, double u2, float alpha);
extern OSErr _SLPSGetFrontProcess(ProcessSerialNumber *psn);
extern void SLSGetConnectionIDForPSN(int cid, ProcessSerialNumber *psn, int *cid_out);
extern void SLSConnectionGetPID(int cid, pid_t *pid_out);

typedef void (^ClickCompletionHandler)(void);

/*********************************
 * Core Helper Functions
 *********************************/

/**
 * Safely release CoreFoundation objects
 * @param ref The reference to release
 */
static void safe_release(CFTypeRef ref) {
    if (ref) CFRelease(ref);
}

/**
 * Get the value of the given attribute
 * @param element The element to get the attribute from
 * @param attribute The attribute to get
 * @param value The value of the attribute (output parameter)
 * @return AXError code
 */
static AXError ax_get_attribute(AXUIElementRef element, CFStringRef attribute, CFTypeRef *value) {
    if (!element || !value || !attribute) {
        return kAXErrorIllegalArgument;
    }
    *value = NULL;
    return AXUIElementCopyAttributeValue(element, attribute, value);
}

/**
 * Get the children of the menubar
 * @param app The application to get the menubar children from
 * @param children The children of the menubar (output parameter)
 * @return AXError code
 */
static AXError ax_get_menubar_children(AXUIElementRef app, CFArrayRef *children) {
    if (!app || !children) {
        return kAXErrorIllegalArgument;
    }
    
    *children = NULL;
    CFTypeRef menubar = NULL;
    AXError error = ax_get_attribute(app, kAXMenuBarAttribute, &menubar);
    
    if (error != kAXErrorSuccess || !menubar) {
        safe_release(menubar);
        return error != kAXErrorSuccess ? error : kAXErrorNoValue;
    }
    
    error = ax_get_attribute(menubar, kAXVisibleChildrenAttribute, (CFTypeRef*)children);
    safe_release(menubar);
    
    return error;
}

/**
 * Get the title of the given element
 * @param element The element to get the title of
 * @return CFStringRef of the title, or NULL on failure. Caller must release.
 */
static CFStringRef ax_get_title(AXUIElementRef element) {
    if (!element) return NULL;
    
    CFTypeRef title = NULL;
    AXError error = ax_get_attribute(element, kAXTitleAttribute, &title);
    
    return (error == kAXErrorSuccess && title) ? (CFStringRef)title : NULL;
}

/**
 * Perform a click action on the given element
 * Uses a dispatch queue to simulate a click with a delay
 *
 * @param element The element to click
 * @param completion The completion handler (can be NULL)
 */
static void ax_perform_click(AXUIElementRef element, ClickCompletionHandler completion) {
    if (!element) {
        if (completion) completion();
        return;
    }
    
    // Cancel any existing action first
    AXUIElementPerformAction(element, kAXCancelAction);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, CLICK_DELAY_MICROSECONDS * NSEC_PER_USEC);
    
    dispatch_after(delay, queue, ^{
        AXUIElementPerformAction(element, kAXPressAction);
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

/**
 * Find a menu extra item by alias
 * @param alias The alias string to search for (format: "OwnerName,WindowName")
 * @return AXUIElementRef of the menu extra item, or NULL if not found. Caller must release.
 */
static AXUIElementRef ax_get_extra_menu_item(const char* alias) {
    if (!alias || strlen(alias) == 0) {
        fprintf(stderr, "Error: Menu extra alias cannot be NULL or empty\n");
        return NULL;
    }

    pid_t target_pid = 0;
    CGRect target_bounds = CGRectNull;
    
    CFArrayRef window_list = CGWindowListCopyWindowInfo(
        kCGWindowListOptionAll,
        kCGNullWindowID
    );

    if (!window_list) {
        fprintf(stderr, "Error: Failed to get window list\n");
        return NULL;
    }

    char owner_buffer[MAX_BUFFER_SIZE] = {0};
    char name_buffer[MAX_BUFFER_SIZE] = {0};
    char combined_buffer[MAX_BUFFER_SIZE] = {0};
    
    CFIndex window_count = CFArrayGetCount(window_list);
    
    for (CFIndex i = 0; i < window_count; ++i) {
        CFDictionaryRef dictionary = (CFDictionaryRef)CFArrayGetValueAtIndex(window_list, i);
        if (!dictionary) continue;

        CFStringRef owner_ref = (CFStringRef)CFDictionaryGetValue(dictionary, kCGWindowOwnerName);
        CFNumberRef owner_pid_ref = (CFNumberRef)CFDictionaryGetValue(dictionary, kCGWindowOwnerPID);
        CFStringRef name_ref = (CFStringRef)CFDictionaryGetValue(dictionary, kCGWindowName);
        CFNumberRef layer_ref = (CFNumberRef)CFDictionaryGetValue(dictionary, kCGWindowLayer);
        CFDictionaryRef bounds_ref = (CFDictionaryRef)CFDictionaryGetValue(dictionary, kCGWindowBounds);

        if (!name_ref || !owner_ref || !owner_pid_ref || !layer_ref || !bounds_ref) {
            continue;
        }

        // Check layer (0x19 is menu bar layer)
        long long layer = 0;
        if (!CFNumberGetValue(layer_ref, kCFNumberLongLongType, &layer) || layer != 0x19) {
            continue;
        }

        // Get owner PID
        uint64_t owner_pid = 0;
        if (!CFNumberGetValue(owner_pid_ref, kCFNumberLongLongType, &owner_pid)) {
            continue;
        }

        // Get bounds
        CGRect bounds = CGRectNull;
        if (!CGRectMakeWithDictionaryRepresentation(bounds_ref, &bounds)) {
            continue;
        }

        // Get strings with buffer overflow protection
        if (!CFStringGetCString(owner_ref, owner_buffer, sizeof(owner_buffer), kCFStringEncodingUTF8) ||
            !CFStringGetCString(name_ref, name_buffer, sizeof(name_buffer), kCFStringEncodingUTF8)) {
            continue;
        }

        // Create combined string with overflow protection
        int written = snprintf(combined_buffer, sizeof(combined_buffer), "%s,%s", owner_buffer, name_buffer);
        if (written >= sizeof(combined_buffer)) {
            continue; // Buffer overflow protection
        }

        // Check if this matches our alias
        if (strcmp(combined_buffer, alias) == 0) {
            target_pid = (pid_t)owner_pid;
            target_bounds = bounds;
            break;
        }
    }

    CFRelease(window_list);
    
    if (!target_pid) {
        return NULL; // Not found, but not an error - caller will handle
    }

    // Create app element and find the matching menu extra
    AXUIElementRef app = AXUIElementCreateApplication(target_pid);
    if (!app) {
        fprintf(stderr, "Error: Failed to create app element for PID %d\n", target_pid);
        return NULL;
    }

    AXUIElementRef result = NULL;
    CFTypeRef extras = NULL;
    CFArrayRef children = NULL;

    do {
        // Get extras menu bar
        AXError error = ax_get_attribute(app, kAXExtrasMenuBarAttribute, &extras);
        if (error != kAXErrorSuccess || !extras) {
            break;
        }

        // Get visible children
        error = ax_get_attribute(extras, kAXVisibleChildrenAttribute, (CFTypeRef*)&children);
        if (error != kAXErrorSuccess || !children) {
            break;
        }

        // Find matching item by position
        CFIndex count = CFArrayGetCount(children);
        for (CFIndex i = 0; i < count; i++) {
            AXUIElementRef item = (AXUIElementRef)CFArrayGetValueAtIndex(children, i);
            if (!item) continue;

            CFTypeRef position_ref = NULL;
            CFTypeRef size_ref = NULL;

            if (ax_get_attribute(item, kAXPositionAttribute, &position_ref) == kAXErrorSuccess &&
                ax_get_attribute(item, kAXSizeAttribute, &size_ref) == kAXErrorSuccess &&
                position_ref && size_ref) {
                
                CGPoint position = CGPointZero;
                CGSize size = CGSizeZero;
                
                if (AXValueGetValue((AXValueRef)position_ref, kAXValueCGPointType, &position) &&
                    AXValueGetValue((AXValueRef)size_ref, kAXValueCGSizeType, &size)) {
                    
                    if (fabs(position.x - target_bounds.origin.x) <= MENU_POSITION_TOLERANCE) {
                        result = (AXUIElementRef)CFRetain(item);
                        safe_release(position_ref);
                        safe_release(size_ref);
                        break;
                    }
                }
            }
            
            safe_release(position_ref);
            safe_release(size_ref);
        }
    } while (0);

    safe_release(extras);
    safe_release(children);
    safe_release(app);

    return result;
}

/*********************************
 * Core Implementation
 *********************************/

MenuError ax_init(void) {
    // First check if we already have permissions
    if (AXIsProcessTrusted()) {
        return MENU_SUCCESS;
    }
    
    // Create options dictionary for permission prompt
    const void *keys[] = { kAXTrustedCheckOptionPrompt };
    const void *values[] = { kCFBooleanTrue };

    CFDictionaryRef options = CFDictionaryCreate(
        kCFAllocatorDefault,
        keys,
        values,
        sizeof(keys) / sizeof(*keys),
        &kCFCopyStringDictionaryKeyCallBacks,
        &kCFTypeDictionaryValueCallBacks
    );

    if (!options) {
        fprintf(stderr, "Error: Failed to create accessibility options dictionary\n");
        return MENU_ERROR_MEMORY;
    }

    bool trusted = AXIsProcessTrustedWithOptions(options);
    CFRelease(options);

    return trusted ? MENU_SUCCESS : MENU_ERROR_ACCESSIBILITY;
}

AXUIElementRef ax_get_front_app(void) {
    ProcessSerialNumber psn;
    
    // Get the front process with error checking
    OSErr err = _SLPSGetFrontProcess(&psn);
    if (err != noErr) {
        fprintf(stderr, "Error: Failed to get front process (error %d)\n", err);
        return NULL;
    }

    int target_cid = 0;
    SLSGetConnectionIDForPSN(SLSMainConnectionID(), &psn, &target_cid);
    
    if (target_cid == 0) {
        fprintf(stderr, "Error: Failed to get connection ID for front process\n");
        return NULL;
    }

    pid_t pid = 0;
    SLSConnectionGetPID(target_cid, &pid);
    
    if (pid == 0) {
        fprintf(stderr, "Error: Failed to get PID for front process\n");
        return NULL;
    }

    AXUIElementRef app = AXUIElementCreateApplication(pid);
    if (!app) {
        fprintf(stderr, "Error: Failed to create accessibility element for PID %d\n", pid);
    }
    
    return app;
}

/*********************************
 * Menu Bar Operations
 *********************************/

MenuError ax_print_menu_options(AXUIElementRef app) {
    if (!app) return MENU_ERROR_INVALID_PARAM;

    CFArrayRef children = NULL;
    AXError error = ax_get_menubar_children(app, &children);
    
    if (error != kAXErrorSuccess) {
        if (error == kAXErrorNoValue) {
            fprintf(stderr, "Error: No menu bar found for application\n");
        } else {
            fprintf(stderr, "Error: Failed to get menu bar children (error %d)\n", error);
        }
        return MENU_ERROR_ACCESSIBILITY;
    }
    
    if (!children) {
        fprintf(stderr, "Error: Menu bar children array is NULL\n");
        return MENU_ERROR_ACCESSIBILITY;
    }

    CFIndex count = CFArrayGetCount(children);
    
    // Start from index 1 to skip the app menu (index 0)
    for (CFIndex i = 1; i < count; i++) {
        AXUIElementRef item = (AXUIElementRef)CFArrayGetValueAtIndex(children, i);
        if (!item) continue;
        
        CFStringRef title = ax_get_title(item);
        if (title) {
            CFIndex length = CFStringGetLength(title);
            if (length > 0) {
                // Calculate buffer size safely
                CFIndex maxSize = CFStringGetMaximumSizeForEncoding(length, kCFStringEncodingUTF8) + 1;
                char* buffer = (char*)malloc(maxSize);
                
                if (buffer) {
                    if (CFStringGetCString(title, buffer, maxSize, kCFStringEncodingUTF8)) {
                        printf("%s\n", buffer);
                    }
                    free(buffer);
                } else {
                    fprintf(stderr, "Error: Failed to allocate memory for menu title\n");
                }
            }
            CFRelease(title);
        }
    }
    
    CFRelease(children);
    return MENU_SUCCESS;
}

MenuError ax_select_menu_option(AXUIElementRef app, int id) {
    if (!app || id < 0) return MENU_ERROR_INVALID_PARAM;

    CFArrayRef children = NULL;
    AXError error = ax_get_menubar_children(app, &children);
    if (error != kAXErrorSuccess) return MENU_ERROR_ACCESSIBILITY;
    
    if (!children) {
        return MENU_ERROR_ACCESSIBILITY;
    }

    CFIndex count = CFArrayGetCount(children);
    MenuError result = MENU_SUCCESS;

    if (id < count) {
        AXUIElementRef item = (AXUIElementRef)CFArrayGetValueAtIndex(children, id);
        if (!item) {
            result = MENU_ERROR_NOT_FOUND;
        } else {
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            
            ax_perform_click(item, ^{
                dispatch_semaphore_signal(semaphore);
            });
            
            // Wait for click to complete with timeout
            dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
            if (dispatch_semaphore_wait(semaphore, timeout) != 0) {
                result = MENU_ERROR_TIMEOUT;
            }
            dispatch_release(semaphore);
        }
    } else {
        result = MENU_ERROR_NOT_FOUND;
    }

    CFRelease(children);
    return result;
}

MenuError ax_select_menu_extra(const char* alias) {
    if (!alias) return MENU_ERROR_INVALID_PARAM;

    AXUIElementRef item = ax_get_extra_menu_item(alias);
    if (!item) return MENU_ERROR_NOT_FOUND;

    int main_connection = SLSMainConnectionID();
    
    // Hide menu bar before click
    SLSSetMenuBarInsetAndAlpha(main_connection, 0, 1, 0.0);
    SLSSetMenuBarVisibilityOverrideOnDisplay(main_connection, 0, true);
    SLSSetMenuBarInsetAndAlpha(main_connection, 0, 1, 0.0);

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    MenuError result = MENU_SUCCESS;

    ax_perform_click(item, ^{
        dispatch_semaphore_signal(semaphore);
    });

    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    if (dispatch_semaphore_wait(semaphore, timeout) != 0) {
        result = MENU_ERROR_TIMEOUT;
    }
    dispatch_release(semaphore);

    // Restore menu bar
    SLSSetMenuBarVisibilityOverrideOnDisplay(main_connection, 0, false);
    SLSSetMenuBarInsetAndAlpha(main_connection, 0, 1, 1.0);

    CFRelease(item);
    return result;
}

const char* menu_error_to_string(MenuError error) {
    switch (error) {
        case MENU_SUCCESS: 
            return "Success";
        case MENU_ERROR_INIT_FAILED: 
            return "Initialization failed - accessibility permissions required";
        case MENU_ERROR_NOT_FOUND: 
            return "Menu item not found";
        case MENU_ERROR_INVALID_PARAM: 
            return "Invalid parameter provided";
        case MENU_ERROR_MEMORY: 
            return "Memory allocation failed";
        case MENU_ERROR_ACCESSIBILITY: 
            return "Accessibility API error - check permissions and try again";
        case MENU_ERROR_TIMEOUT:
            return "Operation timed out";
        default: 
            return "Unknown error";
    }
}

/*********************************
 * Main Entry Point
 *********************************/
int main(int argc, char **argv) {
    if (argc == 1) {
        printf("Usage: %s [-l | -s id/alias ]\n", argv[0]);
        printf("  -l              List menu options for the front application\n");
        printf("  -s id           Select menu option by numeric index\n");
        printf("  -s alias        Select menu extra by alias (format: 'OwnerName,WindowName')\n");
        return 0;
    }

    MenuError error = ax_init();
    if (error != MENU_SUCCESS) {
        fprintf(stderr, "Initialization failed: %s\n", menu_error_to_string(error));
        return 1;
    }

    if (strcmp(argv[1], "-l") == 0) {
        AXUIElementRef app = ax_get_front_app();
        if (!app) {
            fprintf(stderr, "Error: Failed to get front application\n");
            return 1;
        }
        
        error = ax_print_menu_options(app);
        CFRelease(app);

        if (error != MENU_SUCCESS) {
            fprintf(stderr, "Error: %s\n", menu_error_to_string(error));
            return 1;
        }
    } 
    else if (argc == 3 && strcmp(argv[1], "-s") == 0) {
        char *endptr;
        errno = 0;
        long id = strtol(argv[2], &endptr, 10);

        if (errno == 0 && *endptr == '\0' && id >= 0 && id <= INT_MAX) {
            // Numeric ID provided - select menu option
            AXUIElementRef app = ax_get_front_app();
            if (!app) {
                fprintf(stderr, "Error: Could not get front application\n");
                return 1;
            }

            error = ax_select_menu_option(app, (int)id);
            CFRelease(app);

            if (error != MENU_SUCCESS) {
                fprintf(stderr, "Error: %s\n", menu_error_to_string(error));
                return 1;
            }
        } 
        else {
            // String alias provided - select extra menu item
            error = ax_select_menu_extra(argv[2]);
            if (error != MENU_SUCCESS) {
                fprintf(stderr, "Error: %s\n", menu_error_to_string(error));
                return 1;
            }
        }
    }
    else {
        printf("Usage: %s [-l | -s id/alias ]\n", argv[0]);
        printf("  -l              List menu options for the front application\n");
        printf("  -s id           Select menu option by numeric index\n");
        printf("  -s alias        Select menu extra by alias (format: 'OwnerName,WindowName')\n");
        return 1;
    }
    
    return 0;
}
