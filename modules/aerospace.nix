# modules/aerospace.nix
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
  # Implementation
  #─────────────────────────────────────────────────────────────────────────────
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      cfg.package
      (writeShellScriptBin "aerospace-restart" ''
        #!/usr/bin/env bash
        aerospace restart
      '')
    ];
  
    home.file.".aerospace.toml".text = ''
      #───────────────────────────────
      # Core Settings
      #───────────────────────────────
      start-at-login = true
      enable-normalization-flatten-containers = true
      enable-normalization-opposite-orientation-for-nested-containers = true
      accordion-padding = 30
      default-root-container-layout = 'tiles'
      default-root-container-orientation = 'auto'
      automatically-unhide-macos-hidden-apps = true

      # Run Sketchybar together with AeroSpace
      after-startup-command = [
        'exec-and-forget sketchybar',
      ]
      
      # Notify Sketchybar about workspace change
      exec-on-workspace-change = [
        '/bin/bash',
        '-c',
        'sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE',
      ]

      #───────────────────────────────
      # Mouse Settings
      #───────────────────────────────
      on-focused-monitor-changed = ['move-mouse monitor-lazy-center']
      
      on-focus-changed = [
      'move-mouse window-lazy-center'
      'exec-and-forget /bin/bash -c sketchybar --trigger front_app_switched',
      'exec-and-forget sketchybar --trigger update_windows'
      ]

      #───────────────────────────────
      # Key Mapping
      #───────────────────────────────
      [key-mapping]
      preset = 'qwerty'

      #───────────────────────────────
      # Gaps
      #───────────────────────────────
      [gaps]
      inner.horizontal = ${toString cfg.settings.gaps.inner}
      inner.vertical = ${toString cfg.settings.gaps.inner}
      outer.left = ${toString cfg.settings.gaps.outer}
      outer.bottom = ${toString cfg.settings.gaps.outer}
      outer.top = ${toString cfg.settings.gaps.outer}
      outer.right = ${toString cfg.settings.gaps.outer}

      #───────────────────────────────
      # Main Mode Bindings
      #───────────────────────────────
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

      # Focus movement
      alt-h = 'focus left'
      alt-j = 'focus down'
      alt-k = 'focus up'
      alt-l = 'focus right'

      # Window movement
      alt-shift-h = 'move left'
      alt-shift-j = 'move down'
      alt-shift-k = 'move up'
      alt-shift-l = 'move right'

      # Resize windows
      alt-shift-minus = 'resize smart -50'
      alt-shift-equal = 'resize smart +50'

      # Workspace management
      ${lib.concatStringsSep "\n" (map (i: ''
      alt-${toString i} = 'workspace ${toString i}'
      alt-shift-${toString i} = 'move-node-to-workspace ${toString i}'
      '') (lib.range 1 9))}

      # Workspace navigation
      alt-tab = 'workspace-back-and-forth'
      alt-shift-tab = 'move-workspace-to-monitor --wrap-around next'

      # Enter service mode
      alt-shift-semicolon = 'mode service'

      #───────────────────────────────
      # Service Mode Bindings
      #───────────────────────────────
      [mode.service.binding]
      # Reload config and exit service mode
      esc = ['reload-config', 'mode main']

      # Reset layout
      r = ['flatten-workspace-tree', 'mode main']

      # Toggle floating/tiling layout
      f = ['layout floating tiling', 'mode main']

      # Close all windows but current
      backspace = ['close-all-windows-but-current', 'mode main']

      # Join with adjacent windows
      alt-shift-h = ['join-with left', 'mode main']
      alt-shift-j = ['join-with down', 'mode main']
      alt-shift-k = ['join-with up', 'mode main']
      alt-shift-l = ['join-with right', 'mode main']

      #───────────────────────────────
      # Window Detection Rules
      #───────────────────────────────
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: app: lib.optionalString app.enable ''
      [[on-window-detected]]
      if.app-id = '${app.app-id}'
      run = 'move-node-to-workspace ${toString app.workspace}'
      '') cfg.settings.apps)}
    '';
  };
}