{ config, lib, pkgs, ... }:

with lib;

let
    cfg = config.services.sketchybar;
in {
    options.services.sketchybar = {
        enable = mkEnableOption "sketchybar status bar";

        package = mkOption {
            type = types.package;
            default = pkgs.sketchybar;
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

        xdg.configFile."sketchybar/sketchybarrc" = {
            executable = true;
            text = ''
                #!/usr/bin/env sh

                PLUGIN_DIR="$CONFIG_DIR/plugins"

                # Bar appearance
                sketchybar --bar \
                    height=32 \
                    position=top \
                    padding_left=10 \
                    padding_right=10 \
                    color=0xff202020

                # Default values
                sketchybar --default \
                    icon.font="SF Pro:Bold:14.0" \
                    icon.color=0xffffffff \
                    label.font="SF Pro:Bold:14.0" \
                    label.color=0xffffffff \
                    padding_left=5 \
                    padding_right=5 \
                    label.padding_left=4 \
                    label.padding_right=4

                ${cfg.extraConfig}

                # Start sketchybar
                sketchybar --update
            '';
        };

        launchd.agents.sketchybar = {
            enable = true;
            config = {
                ProgramArguments = [ "${cfg.package}/bin/sketchybar" ];
                KeepAlive = true;
                RunAtLoad = true;
            };
        };
    };
}