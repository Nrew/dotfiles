{ lib }:

let
  # Rose Pine base theme colors
  roseTheme = {
    # Base colors
    base = "#191724";
    surface = "#1f1d2e";
    overlay = "#26233a";
    muted = "#6e6a86";
    subtle = "#908caa";
    text = "#e0def4";
    love = "#eb6f92";
    gold = "#f6c177";
    rose = "#ebbcba";
    pine = "#31748f";
    foam = "#9ccfd8";
    iris = "#c4a7e7";
    
    # Semantic colors
    background = "#191724";
    foreground = "#e0def4";
    surface1 = "#1f1d2e";
    surface2 = "#26233a";
    
    # UI colors
    red = "#eb6f92";
    orange = "#ebbcba";
    yellow = "#f6c177";
    green = "#9ccfd8";
    blue = "#31748f";
    magenta = "#c4a7e7";
    cyan = "#9ccfd8";
    white = "#e0def4";
    
    # Additional colors
    accent = "#c4a7e7";
    error = "#eb6f92";
    warning = "#f6c177";
    success = "#9ccfd8";
    info = "#31748f";
    
    # Transparency levels
    alpha = {
      "10" = "1a";
      "20" = "33";
      "30" = "4d";
      "40" = "66";
      "50" = "80";
      "60" = "99";
      "70" = "b3";
      "80" = "cc";
      "90" = "e6";
    };
  };
in
{
  theme = roseTheme;
  
  # Helper function to add transparency to hex colors
  withAlpha = color: alpha: "${color}${alpha}";
  
  # Color palette for terminals
  colorPalette = {
    black = roseTheme.base;
    red = roseTheme.love;
    green = roseTheme.foam;
    yellow = roseTheme.gold;
    blue = roseTheme.pine;
    magenta = roseTheme.iris;
    cyan = roseTheme.foam;
    white = roseTheme.text;
    brightBlack = roseTheme.overlay;
    brightRed = roseTheme.love;
    brightGreen = roseTheme.foam;
    brightYellow = roseTheme.gold;
    brightBlue = roseTheme.pine;
    brightMagenta = roseTheme.iris;
    brightCyan = roseTheme.foam;
    brightWhite = roseTheme.text;
  };
  
  # Catppuccin-compatible exports
  catppuccin = {
    rosewater = roseTheme.rose;
    flamingo = roseTheme.love;
    pink = roseTheme.love;
    mauve = roseTheme.iris;
    red = roseTheme.love;
    maroon = roseTheme.love;
    peach = roseTheme.gold;
    yellow = roseTheme.gold;
    green = roseTheme.foam;
    teal = roseTheme.foam;
    sky = roseTheme.pine;
    sapphire = roseTheme.pine;
    blue = roseTheme.pine;
    lavender = roseTheme.iris;
    text = roseTheme.text;
    subtext1 = roseTheme.subtle;
    subtext0 = roseTheme.muted;
    overlay2 = roseTheme.overlay;
    overlay1 = roseTheme.surface;
    overlay0 = roseTheme.surface;
    surface2 = roseTheme.surface1;
    surface1 = roseTheme.surface;
    surface0 = roseTheme.surface;
    base = roseTheme.base;
    mantle = roseTheme.base;
    crust = roseTheme.base;
  };
}
