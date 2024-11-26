# home/darwin/sketchybar/default.nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sketchybar;
in {
  options.services.sketchybar = {
    enable = mkEnableOption "sketchybar";

    package = mkOption {
      type = types.package;
      default = pkgs.sketchybar;
      defaultText = literalExpression "pkgs.sketchybar";
      description = "The sketchybar package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Additional configuration for sketchybar.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    # Create sketchybar configuration
    xdg.configFile."sketchybar/sketchybarrc" = {
      executable = true;
      text = ''
        #!/bin/bash
        
        PLUGIN_DIR="$HOME/.config/sketchybar/plugins"
        
        # ────────────────────────────────────────────────────────────────
        # Configuration
        # ────────────────────────────────────────────────────────────────

        ${cfg.extraConfig}
      '';
    };

    # Create sketchybar service
    launchd.agents.sketchybar = {
      enable = true;
      config = {
        ProgramArguments = [ "${cfg.package}/bin/sketchybar" ];
        KeepAlive = true;
        RunAtLoad = true;
        EnvironmentVariables = {
          PATH = "${cfg.package}/bin:${pkgs.bash}/bin:${pkgs.coreutils}/bin";
        };
      };
    };
  };
}