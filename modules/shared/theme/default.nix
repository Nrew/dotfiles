{ pkgs, config, lib, ... }:

# ═══════════════════════════════════════════════════════════════════════
# Simple Static Theme System
# ═══════════════════════════════════════════════════════════════════════
#
# This module provides a single static theme for your entire system.
# All applications (kitty, tmux, neovim, btop, etc.) use these colors.
#
# To change the theme:
# 1. Edit the palette values below (or replace with another theme)
# 2. Run: home-manager switch (or darwin-rebuild switch on macOS)
#
# Available color themes to copy from:
# - Beige (current): Warm, minimal light theme
# - Rose Pine: Popular dark purple theme
# - Catppuccin: Soothing pastel themes (latte, frappe, macchiato, mocha)
# - Minimal: Simple monochrome themes
#
# To add a different theme, visit:
# - https://github.com/catppuccin/catppuccin - Catppuccin colors
# - https://rosepinetheme.com/palette - Rose Pine colors
#
# ═══════════════════════════════════════════════════════════════════════

let
  cfg = config.theme;
  
  # ═══════════════════════════════════════════════════════════════════
  # Theme Palette - Edit these values to change your theme!
  # ═══════════════════════════════════════════════════════════════════
  palette = {
    name = "beige";
    
    # Base colors (4)
    base = "#efead8";
    mantle = "#e5e0d0";
    surface = "#cbc2b3";
    overlay = "#a69e93";
    
    # Text colors (4)
    text = "#2d2b28";
    subtext0 = "#45413b";
    subtext1 = "#5a554d";
    muted = "#655f59";
    
    # Accent colors (8)
    primary = "#857a71";
    secondary = "#8f857a";
    red = "#a67070";
    orange = "#b8905e";
    yellow = "#cbb470";
    green = "#8fa670";
    cyan = "#70a6a6";
    blue = "#7a92a6";
    
    # Semantic aliases (reference colors above for consistency)
    background = palette.base;
    success = palette.green;
    warning = palette.orange;
    error = palette.red;
    info = palette.cyan;
    border = palette.overlay;
    selection = palette.overlay;
    cursor = palette.text;
    link = palette.primary;
    subtext = palette.subtext0;
    
    # Legacy compatibility (for backward compatibility)
    love = palette.red;
    gold = palette.yellow;
    foam = palette.cyan;
    pine = palette.green;
    
    # Wallpaper path
    wallpaper = "~/.config/dotfiles/images/wallpapers/BeigeInk.png";
  };
in
{
  options.theme = {
    enable = lib.mkEnableOption "unified theme system";
    
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
    # Make palette available to all modules
    _module.args.palette = palette;
    
    # Export theme colors as environment variables
    home.sessionVariables = {
      THEME_VARIANT = palette.name;
    };
    
    # Export palette as JSON file for scripts that need it
    xdg.configFile."theme/palette.json".text = builtins.toJSON {
      variant = palette.name;
      colors = palette;
      font = cfg.font;
      spacing = { 
        borderRadius = cfg.borderRadius; 
        gap = cfg.gap; 
      };
    };
    
    # Export as shell variables
    xdg.configFile."theme/palette.sh".text = ''
      # Theme: ${palette.name}
      export THEME_VARIANT="${palette.name}"
      
      # Base colors
      export THEME_BASE="${palette.base}"
      export THEME_MANTLE="${palette.mantle}"
      export THEME_SURFACE="${palette.surface}"
      export THEME_OVERLAY="${palette.overlay}"
      
      # Text colors
      export THEME_TEXT="${palette.text}"
      export THEME_SUBTEXT0="${palette.subtext0}"
      export THEME_SUBTEXT1="${palette.subtext1}"
      export THEME_MUTED="${palette.muted}"
      
      # Accent colors
      export THEME_PRIMARY="${palette.primary}"
      export THEME_SECONDARY="${palette.secondary}"
      export THEME_RED="${palette.red}"
      export THEME_ORANGE="${palette.orange}"
      export THEME_YELLOW="${palette.yellow}"
      export THEME_GREEN="${palette.green}"
      export THEME_CYAN="${palette.cyan}"
      export THEME_BLUE="${palette.blue}"
      
      # Semantic colors
      export THEME_BACKGROUND="${palette.background}"
      export THEME_SUCCESS="${palette.success}"
      export THEME_WARNING="${palette.warning}"
      export THEME_ERROR="${palette.error}"
      export THEME_INFO="${palette.info}"
    '';
    
    # Export as CSS variables
    xdg.configFile."theme/palette.css".text = ''
      :root {
        /* Base colors */
        --base: ${palette.base};
        --mantle: ${palette.mantle};
        --surface: ${palette.surface};
        --overlay: ${palette.overlay};
        
        /* Text colors */
        --text: ${palette.text};
        --subtext0: ${palette.subtext0};
        --subtext1: ${palette.subtext1};
        --muted: ${palette.muted};
        
        /* Accent colors */
        --primary: ${palette.primary};
        --secondary: ${palette.secondary};
        --red: ${palette.red};
        --orange: ${palette.orange};
        --yellow: ${palette.yellow};
        --green: ${palette.green};
        --cyan: ${palette.cyan};
        --blue: ${palette.blue};
        
        /* Semantic colors */
        --bg: ${palette.background};
        --success: ${palette.success};
        --warning: ${palette.warning};
        --error: ${palette.error};
        --info: ${palette.info};
      }
    '';
  };
}
