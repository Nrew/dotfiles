{ lib }:

let
  # Helper functions
  withAlpha = color: alpha: "${color}${alpha}";
  
  alpha = {
    "0"   = "00"; "10"  = "1a"; "20"  = "33"; "30"  = "4d";
    "40"  = "66"; "50"  = "80"; "60"  = "99"; "70"  = "b3";
    "80"  = "cc"; "90"  = "e6"; "100" = "ff";
  };
  
  # Theme constructor with defaults
  mkTheme = {
    name,
    background, surface, overlay,
    text, subtext, muted,
    primary, secondary,
    success, warning, error, info,
    border ? overlay,
    selection ? overlay,
    cursor ? text,
    link ? primary,
    syntax ? {}
  }: {
    inherit name background surface overlay text subtext muted
            primary secondary success warning error info
            border selection cursor link alpha withAlpha;
    
    syntax = {
      keyword     = syntax.keyword or primary;
      function    = syntax.function or secondary;
      string      = syntax.string or success;
      number      = syntax.number or warning;
      comment     = syntax.comment or muted;
      type        = syntax.type or info;
      variable    = syntax.variable or text;
      constant    = syntax.constant or secondary;
      operator    = syntax.operator or subtext;
      punctuation = syntax.punctuation or subtext;
    };
  };

  themes = {
    # ════════════════════════════════════════════════════════════════════════
    # Beige Family - Warm, Minimal
    # ════════════════════════════════════════════════════════════════════════
    beige = mkTheme {
      name = "beige";
      background = "#f5f1e8"; surface = "#ede9e0"; overlay = "#e0dcd3";
      text = "#2d2a25"; subtext = "#5a5650"; muted = "#8a857d";
      primary = "#7c8a9e"; secondary = "#9d8b7c";
      success = "#8a9a7b"; warning = "#c9a66b"; error = "#b87d7d"; info = "#7c8a9e";
      border = "#d4cfbf"; selection = "#e8e4d8";
    };

    beige-dark = mkTheme {
      name = "beige-dark";
      background = "#2d2a25"; surface = "#3a3630"; overlay = "#4a453e";
      text = "#f5f1e8"; subtext = "#c4bfb3"; muted = "#8a857d";
      primary = "#a3b4c9"; secondary = "#c9b5a3";
      success = "#a8bc95"; warning = "#dbc08a"; error = "#d19999"; info = "#a3b4c9";
      border = "#5a5650"; selection = "#4a453e";
    };

    # ════════════════════════════════════════════════════════════════════════
    # Rosé Pine Family
    # ════════════════════════════════════════════════════════════════════════
    rose-pine = mkTheme {
      name = "rose-pine";
      background = "#191724"; surface = "#1f1d2e"; overlay = "#26233a";
      text = "#e0def4"; subtext = "#908caa"; muted = "#6e6a86";
      primary = "#c4a7e7"; secondary = "#ebbcba";
      success = "#9ccfd8"; warning = "#f6c177"; error = "#eb6f92"; info = "#31748f";
    };

    rose-pine-moon = mkTheme {
      name = "rose-pine-moon";
      background = "#232136"; surface = "#2a273f"; overlay = "#393552";
      text = "#e0def4"; subtext = "#908caa"; muted = "#6e6a86";
      primary = "#c4a7e7"; secondary = "#ea9a97";
      success = "#9ccfd8"; warning = "#f6c177"; error = "#eb6f92"; info = "#3e8fb0";
    };

    rose-pine-dawn = mkTheme {
      name = "rose-pine-dawn";
      background = "#faf4ed"; surface = "#fffaf3"; overlay = "#f2e9e1";
      text = "#575279"; subtext = "#797593"; muted = "#9893a5";
      primary = "#907aa9"; secondary = "#d7827e";
      success = "#56949f"; warning = "#ea9d34"; error = "#b4637a"; info = "#286983";
    };

    # ════════════════════════════════════════════════════════════════════════
    # Catppuccin Family
    # ════════════════════════════════════════════════════════════════════════
    catppuccin-latte = mkTheme {
      name = "catppuccin-latte";
      background = "#eff1f5"; surface = "#e6e9ef"; overlay = "#ccd0da";
      text = "#4c4f69"; subtext = "#6c6f85"; muted = "#9ca0b0";
      primary = "#8839ef"; secondary = "#ea76cb";
      success = "#40a02b"; warning = "#df8e1d"; error = "#d20f39"; info = "#1e66f5";
    };

    catppuccin-frappe = mkTheme {
      name = "catppuccin-frappe";
      background = "#303446"; surface = "#292c3c"; overlay = "#414559";
      text = "#c6d0f5"; subtext = "#a5adce"; muted = "#838ba7";
      primary = "#ca9ee6"; secondary = "#f4b8e4";
      success = "#a6d189"; warning = "#e5c890"; error = "#e78284"; info = "#8caaee";
    };

    catppuccin-macchiato = mkTheme {
      name = "catppuccin-macchiato";
      background = "#24273a"; surface = "#1e2030"; overlay = "#363a4f";
      text = "#cad3f5"; subtext = "#a5adcb"; muted = "#8087a2";
      primary = "#c6a0f6"; secondary = "#f5bde6";
      success = "#a6da95"; warning = "#eed49f"; error = "#ed8796"; info = "#8aadf4";
    };

    catppuccin-mocha = mkTheme {
      name = "catppuccin-mocha";
      background = "#1e1e2e"; surface = "#181825"; overlay = "#313244";
      text = "#cdd6f4"; subtext = "#a6adc8"; muted = "#7f849c";
      primary = "#cba6f7"; secondary = "#f5c2e7";
      success = "#a6e3a1"; warning = "#f9e2af"; error = "#f38ba8"; info = "#89b4fa";
    };

    # ════════════════════════════════════════════════════════════════════════
    # Minimal Themes
    # ════════════════════════════════════════════════════════════════════════
    minimal-light = mkTheme {
      name = "minimal-light";
      background = "#fafafa"; surface = "#f5f5f5"; overlay = "#e8e8e8";
      text = "#1a1a1a"; subtext = "#4a4a4a"; muted = "#8a8a8a";
      primary = "#3a3a3a"; secondary = "#5a5a5a";
      success = "#4a4a4a"; warning = "#5a5a5a"; error = "#6a6a6a"; info = "#4a4a4a";
    };

    minimal-dark = mkTheme {
      name = "minimal-dark";
      background = "#1a1a1a"; surface = "#252525"; overlay = "#303030";
      text = "#fafafa"; subtext = "#b0b0b0"; muted = "#707070";
      primary = "#d0d0d0"; secondary = "#b0b0b0";
      success = "#a0a0a0"; warning = "#c0c0c0"; error = "#808080"; info = "#b0b0b0";
    };
  };
  
  available = builtins.attrNames themes;

  exists = name: builtins.elem name available;

in
{
  themes // {
    inherit mkTheme available exists;
  }
}

