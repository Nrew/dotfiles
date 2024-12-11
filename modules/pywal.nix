#──────────────────────────────────────────────────────────────────
# pywal.nix - Pywal Color Scheme Manager Configuration
# 
# A NixOS/Home Manager module for managing pywal, which generates and 
# applies color schemes based on wallpapers system-wide.
#──────────────────────────────────────────────────────────────────

{ config, pkgs, lib, ... }:

#──────────────────────────────────────────────────────────────────
# Configuration Variables
#──────────────────────────────────────────────────────────────────
let
  isDarwin = pkgs.stdenv.isDarwin;
  cfg = config.programs.pywal;
in

#──────────────────────────────────────────────────────────────────
# Module Options Definition
#──────────────────────────────────────────────────────────────────
{
  options.programs.pywal = {
    enable = lib.mkEnableOption "pywal color scheme manager";
    
    backend = lib.mkOption {
      type = lib.types.enum [ "wal" "colorz" "haishoku" "schemer2" "colorthief" ];
      default = "wal";
      description = "Color scheme generator backend";
    };

    wallpaper = lib.mkOption {
      type = lib.types.nullOr (lib.types.addCheck lib.types.path builtins.pathExists);
      default = null;
      description = "Default wallpaper path (must exist)";
    };

    reloadServices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of services to reload when colors change";
    };
  };

#──────────────────────────────────────────────────────────────────
# Package and Dependencies Configuration
#──────────────────────────────────────────────────────────────────
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      python3Packages.pywal
      feh  # For setting wallpapers
      imagemagick  # Required for image processing
    ];

    # Ensure cache directory exists
    home.file.".cache/wal/.keep".text = ""; 

#──────────────────────────────────────────────────────────────────
# XDG Configuration
#──────────────────────────────────────────────────────────────────
    xdg.configFile = {
      "wal/config.json".text = lib.generators.toJSON {} {
        inherit (cfg) backend;
        wallpaper = lib.optionalString (cfg.wallpaper != null) "${cfg.wallpaper}";
      };

      # Include templates if a wallpaper is set
      "wal/templates" = lib.mkIf cfg.wallpaper != null {
        source = cfg.wallpaper;
        recursive = true;
      };
    };

#──────────────────────────────────────────────────────────────────
# Service Configuration - Linux
#──────────────────────────────────────────────────────────────────
    systemd.user.services = lib.mkIf (!isDarwin) {
      pywal = {
        Unit = {
          Description = "Pywal color scheme daemon";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.python3Packages.pywal}/bin/wal -R";
          ExecStartPost = map (service: 
            "systemctl --user restart ${service}"
          ) cfg.reloadServices;
          RemainAfterExit = true;
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };

#──────────────────────────────────────────────────────────────────
# Service Configuration - MacOS
#──────────────────────────────────────────────────────────────────
    launchd.agents = lib.mkIf isDarwin {
      pywal = {
        enable = true;
        config = {
          ProgramArguments = [
            "${pkgs.python3Packages.pywal}/bin/wal"
            "-R"
          ];
          RunAtLoad = true;
          KeepAlive = false;
          StandardOutPath = "/tmp/pywal.log";
          StandardErrorPath = "/tmp/pywal.log";
        };
      };
    };
  };
}