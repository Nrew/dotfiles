{ lib }:

let
  # Import DRY utilities
  utils = import ./utils.nix { inherit lib; };
  
  # Re-export utilities for backward compatibility
  inherit (utils) withAlpha alpha;
  
  # 16-color theme constructor
  # Standardized palette: 4 base + 4 text + 8 accent colors
  # This provides a balance between flexibility and simplicity
  # Rationale: 16 colors align with ANSI terminal standards and provide
  # sufficient granularity for modern themes without overwhelming complexity
  mkTheme = {
    name,
    # Base colors (4) - Background layers
    base,      # Main background (darkest/lightest)
    mantle,    # Secondary background layer
    surface,   # Elevated surfaces (cards, panels)
    overlay,   # Overlays, borders, separators
    
    # Text colors (4) - Foreground layers
    text,      # Primary text
    subtext0,  # Secondary text
    subtext1,  # Tertiary text
    muted,     # Muted/disabled text
    
    # Accent colors (8) - Semantic and functional colors
    primary,   # Primary accent/brand color
    secondary, # Secondary accent
    red,       # Errors, critical states
    orange,    # Warnings, alerts
    yellow,    # Cautions, highlights
    green,     # Success, positive states
    cyan,      # Info, links
    blue,      # Info, focus states
    
    # Optional theme metadata
    wallpaper ? null,  # Path to default wallpaper for this theme
    font ? "JetBrainsMono Nerd Font",  # Default font for this theme
  }: 
  let
    # Derive semantic aliases for backward compatibility
    background = base;
    success = green;
    warning = orange;
    error = red;
    info = cyan;
    border = overlay;
    selection = overlay;
    cursor = text;
    link = primary;
    
    # Legacy compatibility (Rose Pine naming)
    love = red;
    gold = yellow;
    foam = cyan;
    pine = green;
  in {
    # Core 16 colors
    inherit name base mantle surface overlay 
            text subtext0 subtext1 muted
            primary secondary red orange yellow green cyan blue;
    
    # Theme metadata
    inherit wallpaper font;
    
    # Derived semantic colors
    inherit background success warning error info
            border selection cursor link alpha withAlpha;
    
    # Legacy compatibility colors
    inherit love gold foam pine;
    
    # Backward compatibility alias
    subtext = subtext0;
    
    # Syntax highlighting using the 16 colors
    syntax = {
      keyword     = primary;
      function    = secondary;
      string      = green;
      number      = orange;
      comment     = muted;
      type        = cyan;
      variable    = text;
      constant    = red;
      operator    = subtext0;
      punctuation = subtext1;
    };  
  };

  themes = {
    # ════════════════════════════════════════════════════════════════════════
    # Beige Family - Warm, Minimal
    # ════════════════════════════════════════════════════════════════════════
    beige = mkTheme {
      name = "beige";
      base = "#efead8"; mantle = "#e5e0d0"; surface = "#cbc2b3"; overlay = "#a69e93";
      text = "#2d2b28"; subtext0 = "#45413b"; subtext1 = "#5a554d"; muted = "#655f59";
      primary = "#857a71"; secondary = "#8f857a";
      red = "#a67070"; orange = "#b8905e"; yellow = "#cbb470"; 
      green = "#8fa670"; cyan = "#70a6a6"; blue = "#7a92a6";
      wallpaper = "~/.config/dotfiles/images/wallpapers/BeigeInk.png";
    };

    beige-dark = mkTheme {
      name = "beige-dark";
      base = "#2d2b28"; mantle = "#353230"; surface = "#45413b"; overlay = "#655f59";
      text = "#efead8"; subtext0 = "#cbc2b3"; subtext1 = "#b3a89c"; muted = "#a69e93";
      primary = "#a69e93"; secondary = "#8f857a";
      red = "#d19999"; orange = "#d1a872"; yellow = "#dbc08a"; 
      green = "#a8bc95"; cyan = "#99d1d1"; blue = "#99b3d1";
    };

    # ════════════════════════════════════════════════════════════════════════
    # Rosé Pine Family
    # ════════════════════════════════════════════════════════════════════════
    rose-pine = mkTheme {
      name = "rose-pine";
      base = "#191724"; mantle = "#1a1826"; surface = "#1f1d2e"; overlay = "#26233a";
      text = "#e0def4"; subtext0 = "#908caa"; subtext1 = "#817c9c"; muted = "#6e6a86";
      primary = "#c4a7e7"; secondary = "#ebbcba";
      red = "#eb6f92"; orange = "#f6a878"; yellow = "#f6c177"; 
      green = "#31748f"; cyan = "#9ccfd8"; blue = "#7e9cd8";
    };

    rose-pine-moon = mkTheme {
      name = "rose-pine-moon";
      base = "#232136"; mantle = "#262339"; surface = "#2a273f"; overlay = "#393552";
      text = "#e0def4"; subtext0 = "#908caa"; subtext1 = "#817c9c"; muted = "#6e6a86";
      primary = "#c4a7e7"; secondary = "#ea9a97";
      red = "#eb6f92"; orange = "#f6a878"; yellow = "#f6c177"; 
      green = "#3e8fb0"; cyan = "#9ccfd8"; blue = "#7e9cd8";
    };

    rose-pine-dawn = mkTheme {
      name = "rose-pine-dawn";
      base = "#faf4ed"; mantle = "#f4ede8"; surface = "#fffaf3"; overlay = "#f2e9e1";
      text = "#575279"; subtext0 = "#797593"; subtext1 = "#8c87a0"; muted = "#9893a5";
      primary = "#907aa9"; secondary = "#d7827e";
      red = "#b4637a"; orange = "#d7a06f"; yellow = "#ea9d34"; 
      green = "#286983"; cyan = "#56949f"; blue = "#5882a4";
    };

    # ════════════════════════════════════════════════════════════════════════
    # Catppuccin Family
    # ════════════════════════════════════════════════════════════════════════
    catppuccin-latte = mkTheme {
      name = "catppuccin-latte";
      base = "#eff1f5"; mantle = "#e6e9ef"; surface = "#dce0e8"; overlay = "#ccd0da";
      text = "#4c4f69"; subtext0 = "#6c6f85"; subtext1 = "#7c7f93"; muted = "#9ca0b0";
      primary = "#8839ef"; secondary = "#ea76cb";
      red = "#d20f39"; orange = "#fe640b"; yellow = "#df8e1d"; 
      green = "#40a02b"; cyan = "#209fb5"; blue = "#1e66f5";
    };

    catppuccin-frappe = mkTheme {
      name = "catppuccin-frappe";
      base = "#303446"; mantle = "#292c3c"; surface = "#232634"; overlay = "#414559";
      text = "#c6d0f5"; subtext0 = "#a5adce"; subtext1 = "#949cbb"; muted = "#838ba7";
      primary = "#ca9ee6"; secondary = "#f4b8e4";
      red = "#e78284"; orange = "#ef9f76"; yellow = "#e5c890"; 
      green = "#a6d189"; cyan = "#81c8be"; blue = "#8caaee";
    };

    catppuccin-macchiato = mkTheme {
      name = "catppuccin-macchiato";
      base = "#24273a"; mantle = "#1e2030"; surface = "#181926"; overlay = "#363a4f";
      text = "#cad3f5"; subtext0 = "#a5adcb"; subtext1 = "#939ab7"; muted = "#8087a2";
      primary = "#c6a0f6"; secondary = "#f5bde6";
      red = "#ed8796"; orange = "#f5a97f"; yellow = "#eed49f"; 
      green = "#a6da95"; cyan = "#8bd5ca"; blue = "#8aadf4";
    };

    catppuccin-mocha = mkTheme {
      name = "catppuccin-mocha";
      base = "#1e1e2e"; mantle = "#181825"; surface = "#11111b"; overlay = "#313244";
      text = "#cdd6f4"; subtext0 = "#a6adc8"; subtext1 = "#9399b2"; muted = "#7f849c";
      primary = "#cba6f7"; secondary = "#f5c2e7";
      red = "#f38ba8"; orange = "#fab387"; yellow = "#f9e2af"; 
      green = "#a6e3a1"; cyan = "#94e2d5"; blue = "#89b4fa";
    };

    # ════════════════════════════════════════════════════════════════════════
    # Minimal Themes
    # ════════════════════════════════════════════════════════════════════════
    minimal-light = mkTheme {
      name = "minimal-light";
      base = "#fafafa"; mantle = "#f5f5f5"; surface = "#f0f0f0"; overlay = "#e8e8e8";
      text = "#1a1a1a"; subtext0 = "#4a4a4a"; subtext1 = "#6a6a6a"; muted = "#8a8a8a";
      primary = "#3a3a3a"; secondary = "#5a5a5a";
      red = "#6a6a6a"; orange = "#5a5a5a"; yellow = "#5a5a5a"; 
      green = "#4a4a4a"; cyan = "#4a4a4a"; blue = "#4a4a4a";
    };

    minimal-dark = mkTheme {
      name = "minimal-dark";
      base = "#1a1a1a"; mantle = "#1f1f1f"; surface = "#252525"; overlay = "#303030";
      text = "#fafafa"; subtext0 = "#b0b0b0"; subtext1 = "#909090"; muted = "#707070";
      primary = "#d0d0d0"; secondary = "#b0b0b0";
      red = "#808080"; orange = "#c0c0c0"; yellow = "#c0c0c0"; 
      green = "#a0a0a0"; cyan = "#b0b0b0"; blue = "#b0b0b0";
    };
  };
  
  # Sort available themes alphabetically for deterministic ordering
  available = builtins.sort (a: b: a < b) (builtins.attrNames themes);

  exists = name: builtins.elem name available;

in themes // { 
    inherit mkTheme available exists;
  }


