{ lib }:

# DRY utilities for theme system
# Single responsibility functions for theme operations

rec {
  # Add alpha transparency to a color
  # Example: withAlpha "#ff0000" "80" -> "#ff000080"
  withAlpha = color: alpha: "${color}${alpha}";
  
  # Common alpha values
  alpha = {
    "0"   = "00"; "10"  = "1a"; "20"  = "33"; "30"  = "4d";
    "40"  = "66"; "50"  = "80"; "60"  = "99"; "70"  = "b3";
    "80"  = "cc"; "90"  = "e6"; "100" = "ff";
  };
  
  # Validate if a string is a valid hex color
  isValidHex = color:
    let
      cleaned = lib.removePrefix "#" color;
      len = builtins.stringLength cleaned;
    in
    (len == 6 || len == 8) && builtins.match "[0-9a-fA-F]+" cleaned != null;
  
  # Normalize color format (ensure # prefix)
  normalizeColor = color:
    if lib.hasPrefix "#" color then color else "#${color}";
  
  # Create a variant of a theme with modified colors
  # Useful for creating light/dark variants
  createVariant = baseTheme: modifications:
    baseTheme // modifications;
  
  # Extract theme colors as shell exports
  # Single responsibility: generate shell environment variables
  toShellExports = palette: prefix:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList
        (name: value: 
          if lib.isString value 
          then ''export ${prefix}_${lib.toUpper name}="${value}"''
          else ""
        )
        palette
    );
  
  # Extract theme colors as CSS variables
  # Single responsibility: generate CSS custom properties
  toCssVars = palette: prefix:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList
        (name: value:
          if lib.isString value
          then "  --${prefix}-${name}: ${value};"
          else ""
        )
        palette
    );
  
  # Create JSON-safe palette (only strings and objects)
  # Single responsibility: filter palette for JSON export
  toJsonSafe = palette:
    lib.filterAttrs (name: value: lib.isString value || lib.isAttrs value) palette;
  
  # Merge multiple palettes with priority (later takes precedence)
  # Single responsibility: combine palettes
  mergePalettes = palettes:
    lib.foldl' (acc: palette: acc // palette) {} palettes;
}
