{ config, lib, pkgs, ... }:

let
  cfg = config.darwin.wm.sketchybar;
in
{
  options.darwin.wm.sketchybar = with lib; {
    enable = mkEnableOption "sketchybar";
    
    package = mkOption {
      type = types.package;
      default = pkgs.sketchybar;
      description = "The sketchybar package to use";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      cfg.package
      lua
      # Any other dependencies needed for your Lua scripts
    ];

    # Link the entire sketchybar config directory structure
    xdg.configFile = {
      # Main entry points
      "sketchybar/sketchybarrc" = {
        source = ./config/sketchybar/sketchybarrc;
        executable = true;
      };
      
      # Lua core files
      "sketchybar/init.lua".source = ./config/sketchybar/init.lua;
      "sketchybar/bar.lua".source = ./config/sketchybar/bar.lua;
      "sketchybar/constants.lua".source = ./config/sketchybar/constants.lua;
      "sketchybar/default.lua".source = ./config/sketchybar/default.lua;

      # Config directory
      "sketchybar/config" = {
        source = ./config/sketchybar/config;
        recursive = true;
      };

      # Items directory
      "sketchybar/items" = {
        source = ./config/sketchybar/items;
        recursive = true;
      };

      # Utils directory
      "sketchybar/utils" = {
        source = ./config/sketchybar/utils;
        recursive = true;
      };

      # Bridge files for C integration
      "sketchybar/bridge" = {
        source = ./config/sketchybar/bridge;
        recursive = true;
      };

      # Installation scripts
      "sketchybar/install" = {
        source = ./config/sketchybar/install;
        recursive = true;
      };
    };

    # Optional: Compile the C bridge if needed
    home.activation.buildSketchybarBridge = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ -f ~/.config/sketchybar/bridge/Makefile ]; then
        cd ~/.config/sketchybar/bridge && make
      fi
    '';
  };
}