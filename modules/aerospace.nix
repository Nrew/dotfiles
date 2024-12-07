{ config, lib, pkgs, ... }:

let 
  cfg = config.darwin.wm.aerospace;
in
{
  #─────────────────────────────────────────────────────────────────────────────
  # Options
  #─────────────────────────────────────────────────────────────────────────────
  options.darwin.wm.aerospace = with lib; {
    enable = mkEnableOption "aerospace window manager";
    
    package = mkOption {
      type = types.package;
      default = pkgs.aerospace;
      description = "The aerospace package to use.";
    };

    settings = mkOption {
      type = types.submodule {
        options = {
          apps = mkOption {
            type = types.attrsOf (types.submodule {
              options = {
                enable = mkEnableOption "application launcher";
                package = mkOption {
                  type = types.package;
                  description = "Application package";
                };
                app-id = mkOption {
                  type = types.str;
                  description = "Application identifier for window detection";
                };
                workspace = mkOption {
                  type = types.int;
                  description = "Default workspace number";
                };
                key = mkOption {
                  type = types.str;
                  description = "Keybind suffix (e.g. 'b' for browser)";
                };
              };
            });
            default = {};
          };

          gaps = mkOption {
            type = types.submodule {
              options = {
                inner = mkOption {
                  type = types.int;
                  default = 6;
                };
                outer = mkOption {
                  type = types.int;
                  default = 6;
                };
              };
            };
            default = {};
          };
        };
      };
      default = {};
    };
  };

  #─────────────────────────────────────────────────────────────────────────────
  # Configuration
  #─────────────────────────────────────────────────────────────────────────────
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      cfg.package
      (writeShellScriptBin "aerospace-restart" ''
        #!/usr/bin/env bash
        aerospace restart
        ${lib.optionalString config.services.sketchybar.enable "sketchybar --reload"}
      '')
    ];
  
    home.file.".aerospace.toml".text = ''
      # Core settings
      start-at-login = true
      enable-normalization-flatten-containers = true
      enable-normalization-opposite-orientation-for-nested-containers = true
      accordion-padding = 30
      default-root-container-layout = 'tiles'
      default-root-container-orientation = 'auto'
      automatically-unhide-macos-hidden-apps = true

      # Mouse settings
      on-focused-monitor-changed = ['move-mouse monitor-lazy-center']
      on-focus-changed = ['move-mouse window-lazy-center']

      # Key mapping
      [key-mapping]
      preset = 'qwerty'

      # Gaps
      [gaps]
      inner.horizontal = ${toString cfg.settings.gaps.inner}
      inner.vertical = ${toString cfg.settings.gaps.inner}
      outer.left = ${toString cfg.settings.gaps.outer}
      outer.bottom = ${toString cfg.settings.gaps.outer}
      outer.top = ${toString cfg.settings.gaps.outer}
      outer.right = ${toString cfg.settings.gaps.outer}

      # Main mode bindings
      [mode.main.binding]
      # Launch applications
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: app: lib.optionalString app.enable ''
      alt-shift-${app.key} = 'exec-and-forget open -na "${app.package}"'
      '') cfg.settings.apps)}

      # Window management
      alt-q = "close"
      alt-slash = 'layout tiles horizontal vertical'
      alt-comma = 'layout accordion horizontal vertical'
      alt-m = 'fullscreen'

      # Focus & Movement
      alt-h = 'focus left'
      alt-j = 'focus down'
      alt-k = 'focus up'
      alt-l = 'focus right'
      alt-shift-h = 'move left'
      alt-shift-j = 'move down'
      alt-shift-k = 'move up'
      alt-shift-l = 'move right'
      alt-shift-minus = 'resize smart -50'
      alt-shift-equal = 'resize smart +50'

      # Workspace management
      ${lib.concatStringsSep "\n" (map (i: ''
      alt-${toString i} = 'workspace ${toString i}'
      alt-shift-${toString i} = 'move-node-to-workspace ${toString i}'
      '') (lib.range 1 9))}
      alt-tab = 'workspace-back-and-forth'
      alt-shift-tab = 'move-workspace-to-monitor --wrap-around next'

      # Service mode
      alt-shift-semicolon = 'mode service'

      [mode.service.binding]
      esc = ['reload-config', 'mode main']
      r = ['flatten-workspace-tree', 'mode main']
      f = ['layout floating tiling', 'mode main']
      backspace = ['close-all-windows-but-current', 'mode main']
      alt-shift-h = ['join-with left', 'mode main']
      alt-shift-j = ['join-with down', 'mode main']
      alt-shift-k = ['join-with up', 'mode main']
      alt-shift-l = ['join-with right', 'mode main']

      # Window detection rules
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: app: lib.optionalString app.enable ''
      [[on-window-detected]]
      if.app-id = '${app.app-id}'
      run = 'move-node-to-workspace ${toString app.workspace}'
      '') cfg.settings.apps)}
    '';

    # Sketchybar integration
    xdg.configFile = lib.mkIf config.services.sketchybar.enable {
      "sketchybar/scripts/aerospace_space_windows.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          SPACE_ICONS=("1" "2" "3" "4" "5")
          CURRENT_SPACE=$(aerospace current-workspace)
          SPACE_WINDOWS=$(aerospace list-windows --workspace "$CURRENT_SPACE" | wc -l)
          
          if [ "$SPACE_WINDOWS" -eq 0 ]; then
            sketchybar --set space."$CURRENT_SPACE" icon.color="$ICON_COLOR"
          else
            sketchybar --set space."$CURRENT_SPACE" icon.color="$LABEL_COLOR"
          fi
        '';
      };
    };
  };
}