{ lib }:

let
  # Import DRY utilities
  utils = import ./utils.nix { inherit lib; };
  
  # Re-export utilities for backward compatibility
  inherit (utils) withAlpha alpha;
  
  # Simplified 12-color theme constructor
  # Follows the Catppuccin/Rose Pine model with exactly 12 colors
  mkTheme = {
    name,
    # Base colors (3)
    base,      # Main background
    surface,   # Elevated surfaces
    overlay,   # Overlays and borders
    
    # Text colors (3)
    text,      # Primary text
    subtext,   # Secondary text
    muted,     # Muted/disabled text
    
    # Accent colors (6)
    primary,   # Primary accent
    secondary, # Secondary accent
    love,      # Red/error states
    gold,      # Yellow/warning states
    foam,      # Cyan/info states
    pine,      # Green/success states
  }: 
  let
    # Derive additional colors for compatibility
    background = base;
    success = pine;
    warning = gold;
    error = love;
    info = foam;
    border = overlay;
    selection = overlay;
    cursor = text;
    link = primary;
  in {
    # Core 12 colors
    inherit name base surface overlay text subtext muted
            primary secondary love gold foam pine;
    
    # Derived colors for backward compatibility
    inherit background success warning error info
            border selection cursor link alpha withAlpha;
    
    # Syntax highlighting using the 12 colors
    syntax = {
      keyword     = primary;
      function    = secondary;
      string      = pine;
      number      = gold;
      comment     = muted;
      type        = foam;
      variable    = text;
      constant    = love;
      operator    = subtext;
      punctuation = subtext;
    };  
  };

  themes = {
    # ════════════════════════════════════════════════════════════════════════
    # Beige Family - Warm, Minimal
    # ════════════════════════════════════════════════════════════════════════
    beige = mkTheme {
      name = "beige";
      base = "#efead8"; surface = "#cbc2b3"; overlay = "#a69e93";
      text = "#2d2b28"; subtext = "#45413b"; muted = "#655f59";
      primary = "#857a71"; secondary = "#8f857a";
      love = "#a67070"; gold = "#cbb470"; foam = "#70a6a6"; pine = "#8fa670";
    };

    beige-dark = mkTheme {
      name = "beige-dark";
      base = "#2d2b28"; surface = "#45413b"; overlay = "#655f59";
      text = "#efead8"; subtext = "#cbc2b3"; muted = "#a69e93";
      primary = "#a69e93"; secondary = "#8f857a";
      love = "#d19999"; gold = "#dbc08a"; foam = "#99d1d1"; pine = "#a8bc95";
    };

    # ════════════════════════════════════════════════════════════════════════
    # Rosé Pine Family
    # ════════════════════════════════════════════════════════════════════════
    rose-pine = mkTheme {
      name = "rose-pine";
      base = "#191724"; surface = "#1f1d2e"; overlay = "#26233a";
      text = "#e0def4"; subtext = "#908caa"; muted = "#6e6a86";
      primary = "#c4a7e7"; secondary = "#ebbcba";
      love = "#eb6f92"; gold = "#f6c177"; foam = "#9ccfd8"; pine = "#31748f";
    };

    rose-pine-moon = mkTheme {
      name = "rose-pine-moon";
      base = "#232136"; surface = "#2a273f"; overlay = "#393552";
      text = "#e0def4"; subtext = "#908caa"; muted = "#6e6a86";
      primary = "#c4a7e7"; secondary = "#ea9a97";
      love = "#eb6f92"; gold = "#f6c177"; foam = "#9ccfd8"; pine = "#3e8fb0";
    };

    rose-pine-dawn = mkTheme {
      name = "rose-pine-dawn";
      base = "#faf4ed"; surface = "#fffaf3"; overlay = "#f2e9e1";
      text = "#575279"; subtext = "#797593"; muted = "#9893a5";
      primary = "#907aa9"; secondary = "#d7827e";
      love = "#b4637a"; gold = "#ea9d34"; foam = "#56949f"; pine = "#286983";
    };

    # ════════════════════════════════════════════════════════════════════════
    # Catppuccin Family
    # ════════════════════════════════════════════════════════════════════════
    catppuccin-latte = mkTheme {
      name = "catppuccin-latte";
      base = "#eff1f5"; surface = "#e6e9ef"; overlay = "#ccd0da";
      text = "#4c4f69"; subtext = "#6c6f85"; muted = "#9ca0b0";
      primary = "#8839ef"; secondary = "#ea76cb";
      love = "#d20f39"; gold = "#df8e1d"; foam = "#1e66f5"; pine = "#40a02b";
    };

    catppuccin-frappe = mkTheme {
      name = "catppuccin-frappe";
      base = "#303446"; surface = "#292c3c"; overlay = "#414559";
      text = "#c6d0f5"; subtext = "#a5adce"; muted = "#838ba7";
      primary = "#ca9ee6"; secondary = "#f4b8e4";
      love = "#e78284"; gold = "#e5c890"; foam = "#8caaee"; pine = "#a6d189";
    };

    catppuccin-macchiato = mkTheme {
      name = "catppuccin-macchiato";
      base = "#24273a"; surface = "#1e2030"; overlay = "#363a4f";
      text = "#cad3f5"; subtext = "#a5adcb"; muted = "#8087a2";
      primary = "#c6a0f6"; secondary = "#f5bde6";
      love = "#ed8796"; gold = "#eed49f"; foam = "#8aadf4"; pine = "#a6da95";
    };

    catppuccin-mocha = mkTheme {
      name = "catppuccin-mocha";
      base = "#1e1e2e"; surface = "#181825"; overlay = "#313244";
      text = "#cdd6f4"; subtext = "#a6adc8"; muted = "#7f849c";
      primary = "#cba6f7"; secondary = "#f5c2e7";
      love = "#f38ba8"; gold = "#f9e2af"; foam = "#89b4fa"; pine = "#a6e3a1";
    };

    # ════════════════════════════════════════════════════════════════════════
    # Minimal Themes
    # ════════════════════════════════════════════════════════════════════════
    minimal-light = mkTheme {
      name = "minimal-light";
      base = "#fafafa"; surface = "#f5f5f5"; overlay = "#e8e8e8";
      text = "#1a1a1a"; subtext = "#4a4a4a"; muted = "#8a8a8a";
      primary = "#3a3a3a"; secondary = "#5a5a5a";
      love = "#6a6a6a"; gold = "#5a5a5a"; foam = "#4a4a4a"; pine = "#4a4a4a";
    };

    minimal-dark = mkTheme {
      name = "minimal-dark";
      base = "#1a1a1a"; surface = "#252525"; overlay = "#303030";
      text = "#fafafa"; subtext = "#b0b0b0"; muted = "#707070";
      primary = "#d0d0d0"; secondary = "#b0b0b0";
      love = "#808080"; gold = "#c0c0c0"; foam = "#b0b0b0"; pine = "#a0a0a0";
    };
  };
  
  available = builtins.attrNames themes;

  exists = name: builtins.elem name available;

in themes // { 
    inherit mkTheme available exists;
  }


