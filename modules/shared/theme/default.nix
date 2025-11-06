{ pkgs, config, lib, ... }:

# ═══════════════════════════════════════════════════════════════════════
# Theme System - Using Catppuccin
# ═══════════════════════════════════════════════════════════════════════
#
# This configuration uses the official Catppuccin Nix module for theming.
# Catppuccin is enabled globally in home/default.nix
#
# To change the flavor (mocha, macchiato, frappe, latte):
# Edit catppuccin.flavor in home/default.nix
#
# To change the accent color (mauve, pink, blue, etc.):
# Edit catppuccin.accent in home/default.nix
#
# Individual applications (kitty, tmux, neovim, btop) have catppuccin enabled
# and will automatically use the selected flavor and accent.
#
# More info: https://github.com/catppuccin/nix
#
# ═══════════════════════════════════════════════════════════════════════

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
  
  config = lib.mkIf cfg.enable {
    # Theme configuration is now handled by Catppuccin module
    # See home/default.nix for catppuccin flavor and accent settings
  };
}
