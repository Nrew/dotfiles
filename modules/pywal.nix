# ────────────────────────────────────────────────────────────────
# pywal.nix - Pywal Color Scheme Manager Configuration
# 
# This module manages pywal for automatic color scheme generation
# and system-wide theming based on wallpapers.
# ────────────────────────────────────────────────────────────────

{ config, pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  options.programs.pywal = {
    enable = lib.mkEnableOption "pywal color scheme manager";
    
    backend = lib.mkOption {
      type = lib.types.enum [ "wal" "colorz" "haishoku" "schemer2" "colorthief" ];
      default = "wal";
      description = "Color scheme generator backend";
    };

    wallpaper = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Default wallpaper path";
    };

    reloadServices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of services to reload when colors change";
    };
  };

  config = lib.mkIf config.programs.pywal.enable {
    home.packages = with pkgs; [
      python3Packages.pywal
      imagemagick
    ];

    # Integrate with home-manager's XDG specification
    xdg.configFile."wal/config.json".text = lib.generators.toJSON {} {
      inherit (config.programs.pywal) backend;
      wallpaper = "${config.programs.pywal.wallpaper}";
    };

    # Proper service integration
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
          ) config.programs.pywal.reloadServices;
          RemainAfterExit = true;
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };

    # Darwin service integration
    launchd.user.agents = lib.mkIf isDarwin {
      pywal = {
        serviceConfig = {
          ProgramArguments = [
            "${pkgs.python3Packages.pywal}/bin/wal"
            "-R"
          ];
          RunAtLoad = true;
          KeepAlive = false;
        };
      };
    };

    # Shell integration
    programs.bash.initExtra = ''
      source ~/.cache/wal/colors.sh
    '';
    
    programs.zsh.initExtra = ''
      source ~/.cache/wal/colors.sh
    '';

    # Ensure cache directory exists
    home.file.".cache/wal/.keep".text = "";
  };
}