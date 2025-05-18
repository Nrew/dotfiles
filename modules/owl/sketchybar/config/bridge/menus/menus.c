#include "menus.h"

/*********************************
 * Private SLS API Declarations
 *********************************/
extern int SLSMainConnectionID(void);
extern void SLSSetMenuBarVisibilityOverrideOnDisplay(int cid, int did, bool enabled);
extern void SLSSetMenuBarInsetAndAlpha(int cid, double u1, double u2, float alpha);
extern void _SLPSGetFrontProcess(ProcessSerialNumber *psn);
extern void SLSGetConnectionIDForPSN(int cid, ProcessSerialNumber *psn, int *cid_out);
extern void SLSConnectionGetPID(int cid, pid_t *pid_out);

typedef void (^ClickCompletionHandler)(void);

/*********************************
 * Core Helper Functions
 *********************************/

/**
 * Perform a click action on the given element
 * @param element The element to click
 * @return void
 */
static void safe_release(CFTypeRef ref) {
  if (ref) CFRelease(ref);
}

/**
 * Get the value of the given attribute
 * @param element The element to get the attribute from
 * @param attribute The attribute to get
 * @param value The value of the attribute
 * @return AXError code
 */
static AXError ax_get_attribute(AXUIElementRef element, CFStringRef attribute, CFTypeRef *value) {
    if (!element || !value) return kAXErrorIllegalArgument;
    return AXUIElementCopyAttributeValue(element, attribute, value);
}

/**
 * Get the children of the menubar
 * @param app The application to get the menubar children from
 * @param children The children of the menubar
 * @return AXError code
 */
static AXError ax_get_menubar_children(AXUIElementRef app, CFArrayRef *children) {
    if (!app || !children) return kAXErrorIllegalArgument;
    
    CFTypeRef menubar = NULL;
    AXError error = ax_get_attribute(app, kAXMenuBarAttribute, &menubar);
    if (error != kAXErrorSuccess) return error;
    
    error = ax_get_attribute(menubar, kAXVisibleChildrenAttribute, (CFTypeRef*)children);
    CFRelease(menubar);
    
    return error;
}

/**
 * Get the title of the given element
 * @param element The element to get the title of
 * @return CFStringRef of the title, or NULL on failure
 */
static CFStringRef ax_get_title(AXUIElementRef element) {
    if (!element) return NULL;
    CFTypeRef title = NULL;
    return (ax_get_attribute(element, kAXTitleAttribute, &title) == kAXErrorSuccess) ? title : NULL;
}

/**
 * Perform a click action on the given element
 * Uses a dispatch queue to simulate a click with a delay
 *
 * @param element The element to click
 * @param completion The completion handler
 * @return void
 */
static void ax_perform_click(AXUIElementRef element, ClickCompletionHandler completion) {
    if (!element) {
        if (completion) completion();
        return;
    }
    
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

/*********************************
 * Core Implementation
 *********************************/

MenuError ax_init(void) {
  const void *keys[] = { kAXTrustedCheckOptionPrompt };
  const void *values[] = { kCFBooleanTrue };

  CFDictionaryRef options;
  options = CFDictionaryCreate(             // Create dictionary
    kCFAllocatorDefault,                    // Allocator
    keys,                                   // keys
    values,                                 // Values
    sizeof(keys) / sizeof(*keys),           // Key count
    &kCFCopyStringDictionaryKeyCallBacks,   // Key callbacks
    &kCFTypeDictionaryValueCallBacks        // Value callbacks
  );    

  if (!options) return MENU_ERROR_MEMORY;   // Check for failure

  bool trusted = AXIsProcessTrustedWithOptions(options);
  CFRelease(options);                       // Release the dictionary

  return trusted ? MENU_SUCCESS : MENU_ERROR_ACCESSIBILITY;
}

AXUIElementRef ax_get_front_app(void) {
  ProcessSerialNumber psn;                  // Process serial number
  _SLPSGetFrontProcess(&psn);               // Get front process

  int target_cid;
  SLSGetConnectionIDForPSN(                 // Get connection id
    SLSMainConnectionID(),                  // Main connection id
    &psn,                                   // Process serial number           
    &target_cid                             // Target connection id
  ); 

  pid_t pid;                                // Process id             
  SLSConnectionGetPID(target_cid, &pid);    // Get process id

  return AXUIElementCreateApplication(pid); // Create application
}

/*********************************
 * Menu Bar Operations
 *********************************/

MenuError ax_print_menu_options(AXUIElementRef app) {
    if (!app) return MENU_ERROR_INVALID_PARAM;

    CFArrayRef children = NULL;
    AXError error = ax_get_menubar_children(app, &children);
    if (error != kAXErrorSuccess) return MENU_ERROR_ACCESSIBILITY;

    uint32_t count = CFArrayGetCount(children);
    for (uint32_t i = 1; i < count; i++) {
        AXUIElementRef item = CFArrayGetValueAtIndex(children, i);
        CFTypeRef title = ax_get_title(item);

        if (title) {
            CFIndex length = CFStringGetLength(title);
            if (length > 0) {
                // Allocate buffer dynamically with proper size
                CFIndex maxSize = CFStringGetMaximumSizeForEncoding(length, kCFStringEncodingUTF8) + 1;
                char* buffer = (char*)malloc(maxSize);
                
                if (buffer) {
                    if (CFStringGetCString(title, buffer, maxSize, kCFStringEncodingUTF8)) {
                        printf("%s\n", buffer);
                    }
                    free(buffer);
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

    MenuError result = MENU_SUCCESS;
    uint32_t count = CFArrayGetCount(children);

    if (id < (int)count) {
        AXUIElementRef item = CFArrayGetValueAtIndex(children, id);
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        ax_perform_click(item, ^{
            dispatch_semaphore_signal(semaphore);
        });
        
        // Wait for click to complete with timeout
        if (dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC)) != 0) {
            result = MENU_ERROR_ACCESSIBILITY;
        }
        dispatch_release(semaphore);
    } 
    else {
        result = MENU_ERROR_NOT_FOUND;
    }

  CFRelease(children);
  return result;
}

static AXUIElementRef ax_get_extra_menu_item(const char* alias) {
    if (!alias) return NULL;

    pid_t pid = 0;
    CGRect bounds = CGRectNull;
    CFArrayRef window_list = CGWindowListCopyWindowInfo(
        kCGWindowListOptionAll,
        kCGNullWindowID
    );

    if (!window_list) return NULL;

    char owner_buffer[MAX_BUFFER_SIZE] = {0};
    char name_buffer[MAX_BUFFER_SIZE] = {0};
    char buffer[MAX_BUFFER_SIZE] = {0};
    
    int window_count = CFArrayGetCount(window_list);
    for (int i = 0; i < window_count; ++i) {
        CFDictionaryRef dictionary = CFArrayGetValueAtIndex(window_list, i);
        if (!dictionary) continue;

        CFStringRef owner_ref = CFDictionaryGetValue(dictionary, kCGWindowOwnerName);
        CFNumberRef owner_pid_ref = CFDictionaryGetValue(dictionary, kCGWindowOwnerPID);
        CFStringRef name_ref = CFDictionaryGetValue(dictionary, kCGWindowName);
        CFNumberRef layer_ref = CFDictionaryGetValue(dictionary, kCGWindowLayer);
        CFDictionaryRef bounds_ref = CFDictionaryGetValue(dictionary, kCGWindowBounds);

        if (!name_ref || !owner_ref || !owner_pid_ref || !layer_ref || !bounds_ref)
            continue;

        long long int layer = 0;
        CFNumberGetValue(layer_ref, CFNumberGetType(layer_ref), &layer);
        uint64_t owner_pid = 0;
        CFNumberGetValue(owner_pid_ref, CFNumberGetType(owner_pid_ref), &owner_pid);

        if (layer != 0x19) continue;

        bounds = CGRectNull;
        if (!CGRectMakeWithDictionaryRepresentation(bounds_ref, &bounds)) continue;

        if (!CFStringGetCString(owner_ref, owner_buffer, sizeof(owner_buffer), kCFStringEncodingUTF8) ||
            !CFStringGetCString(name_ref, name_buffer, sizeof(name_buffer), kCFStringEncodingUTF8))
            continue;

        if (snprintf(buffer, sizeof(buffer), "%s,%s", owner_buffer, name_buffer) >= sizeof(buffer))
            continue;

        if (strcmp(buffer, alias) == 0) {
            pid = owner_pid;
            break;
        }
    }

    CFRelease(window_list);
    if (!pid) return NULL;

    AXUIElementRef app = AXUIElementCreateApplication(pid);
    if (!app) return NULL;

    AXUIElementRef result = NULL;
    CFTypeRef extras = NULL;
    CFArrayRef children = NULL;

    if (ax_get_attribute(app, kAXExtrasMenuBarAttribute, &extras) == kAXErrorSuccess) {
        if (ax_get_attribute(extras, kAXVisibleChildrenAttribute, (CFTypeRef*)&children) == kAXErrorSuccess) {
            uint32_t count = CFArrayGetCount(children);
            for (uint32_t i = 0; i < count; i++) {
                AXUIElementRef item = CFArrayGetValueAtIndex(children, i);
                CFTypeRef position_ref = NULL;
                CFTypeRef size_ref = NULL;

                ax_get_attribute(item, kAXPositionAttribute, &position_ref);
                ax_get_attribute(item, kAXSizeAttribute, &size_ref);

                if (!position_ref || !size_ref) {
                    safe_release(position_ref);
                    safe_release(size_ref);
                    continue;
                }

                CGPoint position = CGPointZero;
                CGSize size = CGSizeZero;
                AXValueGetValue(position_ref, kAXValueCGPointType, &position);
                AXValueGetValue(size_ref, kAXValueCGSizeType, &size);

                safe_release(position_ref);
                safe_release(size_ref);

                if (fabs(position.x - bounds.origin.x) <= MENU_POSITION_TOLERANCE) {
                    result = (AXUIElementRef)CFRetain(item);
                    break;
                }
            }
        }
    }

    safe_release(extras);
    safe_release(children);
    safe_release(app);

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

    if (dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC)) != 0) {
        result = MENU_ERROR_ACCESSIBILITY;
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
        case MENU_SUCCESS: return "Success";
        case MENU_ERROR_INIT_FAILED: return "Initialization failed - accessibility permissions required";
        case MENU_ERROR_NOT_FOUND: return "Menu item not found";
        case MENU_ERROR_INVALID_PARAM: return "Invalid parameter provided";
        case MENU_ERROR_MEMORY: return "Memory allocation failed";
        case MENU_ERROR_ACCESSIBILITY: return "Accessibility API error";
        default: return "Unknown error";
    }
}

/*********************************
 * Main Entry Point
 *********************************/
int main(int argc, char **argv) {
  if (argc == 1) {
      printf("Usage: %s [-l | -s id/alias ]\n", argv[0]);
      return 0;
  }

  MenuError error = ax_init(); // Will exit if not trusted
  if (error != MENU_SUCCESS) {
      fprintf(stderr, "Error: %s\n", menu_error_to_string(error));
      return 1;
  }

  if (strcmp(argv[1], "-l") == 0) {
      AXUIElementRef app = ax_get_front_app();

      if (!app) {
        fprintf(stderr, "Failed to get front app\n");
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
    return 1;
  }
  return 0;
}
