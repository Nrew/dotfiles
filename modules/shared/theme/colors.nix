{ lib }:

let
  # Helper to add alpha transparency
  withAlpha = color: alpha: "${color}${alpha}";
  
  # Alpha levels as hex values
  alpha = {
    "0"   = "00";
    "10"  = "1a";
    "20"  = "33";
    "30"  = "4d";
    "40"  = "66";
    "50"  = "80";
    "60"  = "99";
    "70"  = "b3";
    "80"  = "cc";
    "90"  = "e6";
    "100" = "ff";
  };
  
  # Color palette generator
  mkPalette = {
    # Core colors
    background,
    surface,
    overlay,
    
    # Text colors
    text,
    subtext,
    muted,
    
    # Accent colors
    primary,
    secondary,
    
    # Status colors
    success,
    warning,
    error,
    info,
    
    # Additional semantic colors
    border ? overlay,
    selection ? overlay,
    cursor ? primary,
    link ? primary,
    
    # Syntax highlighting
    syntax ? {}
  }: {
    inherit 
      background surface overlay
      text subtext muted
      primary secondary
      success warning error info
      border selection cursor link
      alpha withAlpha;
      
    # Syntax highlighting defaults
    syntax = {
      keyword    = syntax.keyword or primary;
      function   = syntax.function or secondary;
      string     = syntax.string or success;
      number     = syntax.number or warning;
      comment    = syntax.comment or muted;
      type       = syntax.type or info;
      variable   = syntax.variable or text;
      constant   = syntax.constant or secondary;
      operator   = syntax.operator or subtext;
      punctuation = syntax.punctuation or subtext;
    };
    
    # Legacy aliases for compatibility
    base = background;
    fg = text;
    bg = background;
  };

in
{
  # Beige (Default) - Warm, soft, minimal aesthetic
  beige = mkPalette {
    # Backgrounds (warm beige tones)
    background = "#f5f1e8";  # Soft cream
    surface    = "#ede9e0";  # Slightly darker cream
    overlay    = "#e0dcd3";  # Warm gray-beige
    
    # Text (warm grays and blacks)
    text    = "#2d2a25";  # Warm black
    subtext = "#5a5650";  # Medium warm gray
    muted   = "#8a857d";  # Light warm gray
    
    # Accents (muted, sophisticated)
    primary   = "#7c8a9e";  # Muted blue-gray
    secondary = "#9d8b7c";  # Warm taupe
    
    # Status colors (muted, harmonious)
    success = "#8a9a7b";  # Muted sage green
    warning = "#c9a66b";  # Warm gold
    error   = "#b87d7d";  # Muted red
    info    = "#7c8a9e";  # Muted blue
    
    # UI elements
    border    = "#d4cfbf";
    selection = "#e8e4d8";
    cursor    = "#2d2a25";
    link      = "#7c8a9e";
  };
  
  # Beige Dark - For those who want dark mode with warmth
  beige-dark = mkPalette {
    # Backgrounds (warm dark tones)
    background = "#2d2a25";  # Warm black
    surface    = "#3a3630";  # Dark warm gray
    overlay    = "#4a453e";  # Medium dark warm gray
    
    # Text (warm light tones)
    text    = "#f5f1e8";  # Soft cream
    subtext = "#c4bfb3";  # Light warm gray
    muted   = "#8a857d";  # Medium warm gray
    
    # Accents
    primary   = "#a3b4c9";  # Lighter muted blue
    secondary = "#c9b5a3";  # Lighter warm taupe
    
    # Status colors
    success = "#a8bc95";
    warning = "#dbc08a";
    error   = "#d19999";
    info    = "#a3b4c9";
    
    # UI elements
    border    = "#5a5650";
    selection = "#4a453e";
    cursor    = "#f5f1e8";
    link      = "#a3b4c9";
  };
  
  # Minimal Gray - Pure monochrome
  minimal = mkPalette {
    background = "#fafafa";
    surface    = "#f5f5f5";
    overlay    = "#e8e8e8";
    
    text    = "#1a1a1a";
    subtext = "#4a4a4a";
    muted   = "#8a8a8a";
    
    primary   = "#3a3a3a";
    secondary = "#5a5a5a";
    
    success = "#4a4a4a";
    warning = "#5a5a5a";
    error   = "#6a6a6a";
    info    = "#4a4a4a";
  };
  
  # High Contrast - For accessibility
  high-contrast = mkPalette {
    background = "#ffffff";
    surface    = "#f8f8f8";
    overlay    = "#eeeeee";
    
    text    = "#000000";
    subtext = "#333333";
    muted   = "#666666";
    
    primary   = "#0066cc";
    secondary = "#cc6600";
    
    success = "#008800";
    warning = "#cc8800";
    error   = "#cc0000";
    info    = "#0066cc";
  };
  
  # Inherit the mkPalette function for custom themes
  inherit mkPalette alpha withAlpha;
}
