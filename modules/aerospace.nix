# modules/rice/aerospace/default.nix
{ config, lib, pkgs, ... }:

{
  # Install aerospace
  home.packages = with pkgs; [
    aerospace
  ];

  # Main aerospace configuration
  xdg.configFile."aerospace/config.json".text = ''
    {
      "layouts": {
        "tall": {
          "tile": "tall",
          "gaps": {
            "inner": 8,
            "outer": 8
          }
        },
        "wide": {
          "tile": "wide",
          "gaps": {
            "inner": 8,
            "outer": 8
          }
        },
        "stack": {
          "tile": "stack",
          "gaps": {
            "inner": 0,
            "outer": 8
          }
        },
        "float": {
          "tile": "float",
          "gaps": {
            "inner": 0,
            "outer": 0
          }
        }
      },
      
      "spaces": {
        "1": {
          "layout": "tall",
          "displayLayout": true,
          "label": "1"
        },
        "2": {
          "layout": "wide",
          "displayLayout": true,
          "label": "2"
        },
        "3": {
          "layout": "tall",
          "displayLayout": true,
          "label": "3"
        },
        "4": {
          "layout": "stack",
          "displayLayout": true,
          "label": "4"
        },
        "5": {
          "layout": "float",
          "displayLayout": true,
          "label": "5"
        }
      },

      "windowRules": {
        "kitty": {
          "space": "1"
        },
        "Firefox": {
          "space": "2"
        },
        "Discord": {
          "space": "3"
        },
        "Spotify": {
          "space": "4"
        },
        "System Settings": {
          "space": "5",
          "float": true
        },
        "Calculator": {
          "float": true
        },
        "System Information": {
          "float": true
        }
      },

      "bindings": {
        "ctrl-cmd-t": "aerospace quit",
        "ctrl-cmd-r": "aerospace restart",
        
        // Focus windows
        "cmd-h": "aerospace focus west",
        "cmd-j": "aerospace focus south",
        "cmd-k": "aerospace focus north",
        "cmd-l": "aerospace focus east",
        
        // Move windows
        "shift-cmd-h": "aerospace move west",
        "shift-cmd-j": "aerospace move south",
        "shift-cmd-k": "aerospace move north",
        "shift-cmd-l": "aerospace move east",
        
        // Resize windows
        "shift-alt-h": "aerospace resize west",
        "shift-alt-j": "aerospace resize south",
        "shift-alt-k": "aerospace resize north",
        "shift-alt-l": "aerospace resize east",
        
        // Space management
        "cmd-1": "aerospace space 1",
        "cmd-2": "aerospace space 2",
        "cmd-3": "aerospace space 3",
        "cmd-4": "aerospace space 4",
        "cmd-5": "aerospace space 5",
        
        // Move windows to spaces
        "shift-cmd-1": "aerospace move-to-space 1",
        "shift-cmd-2": "aerospace move-to-space 2",
        "shift-cmd-3": "aerospace move-to-space 3",
        "shift-cmd-4": "aerospace move-to-space 4",
        "shift-cmd-5": "aerospace move-to-space 5",
        
        // Layout management
        "cmd-space": "aerospace layout-rotate",
        "shift-cmd-space": "aerospace layout-flip",
        "cmd-b": "aerospace toggle-float",
        "cmd-f": "aerospace toggle-fullscreen",
        
        // Window management
        "cmd-w": "aerospace close",
        "cmd-e": "aerospace equalize",
        
        // Layout switching
        "alt-1": "aerospace layout tall",
        "alt-2": "aerospace layout wide",
        "alt-3": "aerospace layout stack",
        "alt-4": "aerospace layout float"
      },

      "general": {
        "padding": 4,
        "margins": 8,
        "smartGaps": true,
        "windowMargins": true,
        "windowResizeStep": 50,
        "layoutResizeStep": 0.05,
        "floatingResizeStep": 50,
        "mouseFollowsFocus": false,
        "focusFollowsMouse": false,
        "stickyFloatingWindows": false
      }
    }
  '';

  # Add helper scripts
  home.packages = with pkgs; [
    (writeShellScriptBin "aerospace-restart" ''
      #!/usr/bin/env bash
      # Restart aerospace and refresh sketchybar
      aerospace restart
      sketchybar --reload
    '')
  ];

  # Add to sketchybar scripts for space updates
  xdg.configFile."sketchybar/scripts/aerospace_space_windows.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      
      SPACE_ICONS=("1" "2" "3" "4" "5")
      
      # Get current space from aerospace
      CURRENT_SPACE=$(aerospace space current)
      SPACE_WINDOWS=$(aerospace space windows $CURRENT_SPACE | wc -l)
      
      # Update the icon based on number of windows
      if [ "$SPACE_WINDOWS" -eq 0 ]; then
        sketchybar --set space.$CURRENT_SPACE icon.color=$ICON_COLOR
      else
        sketchybar --set space.$CURRENT_SPACE icon.color=$LABEL_COLOR
      fi
    '';
  };
}