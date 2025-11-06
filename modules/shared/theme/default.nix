{ pkgs, config, lib, ... }:

let
  cfg = config.theme;
in
{
  options.theme = {
    enable = lib.mkEnableOption "theme configuration options";
    
    font = {
      mono = lib.mkOption {
        type = lib.types.str;
        default = "JetBrainsMono Nerd Font";
        description = "Monospace font";
      };
      sans = lib.mkOption {
        type = lib.types.str;
        default = "Inter";
        description = "Sans-serif font";
      };
      size = {
        small = lib.mkOption { type = lib.types.int; default = 12; };
        normal = lib.mkOption { type = lib.types.int; default = 14; };
        large = lib.mkOption { type = lib.types.int; default = 16; };
      };
    };
    
    borderRadius = lib.mkOption { 
      type = lib.types.int; 
      default = 8;
      description = "Border radius in pixels";
    };
    
    gap = lib.mkOption { 
      type = lib.types.int; 
      default = 16;
      description = "Gap/padding size in pixels";
    };
    
    wallpaperDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/.config/dotfiles/images/wallpapers";
      description = "Wallpaper directory path";
    };
  };
}