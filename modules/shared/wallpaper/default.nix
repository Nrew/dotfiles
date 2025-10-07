{ config, lib, pkgs, palette, system, ... }:

# Wallpaper management module for nix-darwin
# This module provides a Nix-focused wallpaper manager using gowall (for macOS)
# - Integrates with gowall for efficient wallpaper management
# - Supports theme system integration
# - Platform-aware (uses gowall on macOS, fallback on Linux)

let
  cfg = config.wallpaper;
  wallpaperDir = config.theme.wallpaperDir;
  isDarwin = lib.hasSuffix "darwin" system;

  # Gowall wrapper for macOS with image preview support
  gowallWrapper = pkgs.writeShellScriptBin "wallpaper" ''
    #!/usr/bin/env bash
    set -euo pipefail

    # Colors for better UX
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color

    WALLPAPER_DIR="${wallpaperDir}"

    # Validate wallpaper directory exists
    if [ ! -d "$WALLPAPER_DIR" ]; then
      echo -e "''${RED}Error: Wallpaper directory not found: $WALLPAPER_DIR''${NC}" >&2
      echo -e "''${YELLOW}Please create the directory or update theme.wallpaperDir in your configuration.''${NC}" >&2
      exit 1
    fi

    # If no arguments provided, use gowall interactively to select and process wallpaper
    if [ $# -eq 0 ]; then
      cd "$WALLPAPER_DIR"

      # Find all image files
      IMAGES=$(${pkgs.findutils}/bin/find . -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) 2>/dev/null)

      if [ -z "$IMAGES" ]; then
        echo -e "''${YELLOW}No images found in $WALLPAPER_DIR''${NC}"
        exit 0
      fi

      # Use fzf to select an image
      SELECTED=$(echo "$IMAGES" | sed 's|^\./||' | ${pkgs.fzf}/bin/fzf \
        --height=100% \
        --border=rounded \
        --prompt="🖼️  Select wallpaper: " \
        --preview="${pkgs.imagemagick}/bin/identify -verbose {} | head -20" \
        --preview-window=right:50%) || exit 0

      if [ -n "$SELECTED" ]; then
        echo -e "''${BLUE}Processing wallpaper: $SELECTED''${NC}"
        ${pkgs.gowall}/bin/gowall "$SELECTED"
        echo -e "''${GREEN}✅ Wallpaper and theme applied: $SELECTED''${NC}"
      fi
    else
      # Pass arguments directly to gowall for full theme generation
      cd "$WALLPAPER_DIR"
      ${pkgs.gowall}/bin/gowall "$@"
    fi
  '';

  # Fallback selector for non-macOS systems
  fzfWallpaperSelector = pkgs.writeShellScriptBin "wallpaper" ''
    #!/usr/bin/env bash
    set -euo pipefail

    # Colors for better UX
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color

    WALLPAPER_DIR="${wallpaperDir}"
    CURRENT_LINK="${config.xdg.stateHome}/current-wallpaper"

    # Source theme palette if available
    PALETTE_FILE="${config.xdg.configHome}/theme/palette.sh"
    [ -f "$PALETTE_FILE" ] && source "$PALETTE_FILE"

    if [ ! -d "$WALLPAPER_DIR" ]; then
      echo -e "''${RED}Error: Wallpaper directory not found: $WALLPAPER_DIR''${NC}" >&2
      exit 1
    fi

    # Image preview function for fzf
    preview_image() {
      local file="$1"

      if [ -n "''${KITTY_WINDOW_ID:-}" ]; then
        ${pkgs.kitty}/bin/kitten icat \
          --clear \
          --transfer-mode=memory \
          --stdin=no \
          --place=''${FZF_PREVIEW_COLUMNS}x''${FZF_PREVIEW_LINES}@0x0 \
          "$file" 2>/dev/null
      else
        echo "File: $(basename "$file")"
        echo "Size: $(${pkgs.coreutils}/bin/du -h "$file" | cut -f1)"
        if ${pkgs.imagemagick}/bin/identify -version &> /dev/null; then
          local dims=$(${pkgs.imagemagick}/bin/identify -format "%wx%h" "$file" 2>/dev/null)
          [ -n "$dims" ] && echo "Dimensions: $dims"
        fi
      fi
    }

    export -f preview_image

    SELECTED=$(${pkgs.findutils}/bin/find "$WALLPAPER_DIR" -type f \
      \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) 2>/dev/null | \
      sed "s|$WALLPAPER_DIR/||" | \
      sort | \
      ${pkgs.fzf}/bin/fzf \
        --height=100% \
        --border=rounded \
        --preview="preview_image \"$WALLPAPER_DIR/{}\"" \
        --preview-window=right:60% \
        --prompt="🖼️  " \
        --color="fg:''${THEME_TEXT:-${palette.text}},bg:''${THEME_OVERLAY:-${palette.overlay}}" \
        --pointer="▶") || exit 0

    [ -z "$SELECTED" ] && exit 0

    WALLPAPER_PATH="$WALLPAPER_DIR/$SELECTED"
    mkdir -p "$(dirname "$CURRENT_LINK")"
    ln -sf "$WALLPAPER_PATH" "$CURRENT_LINK"

    echo -e "''${GREEN}✅ Wallpaper set: $SELECTED''${NC}"
  '';

in
{
  options.wallpaper = {
    enable = lib.mkEnableOption "wallpaper management";
  };

  config = lib.mkIf (config.theme.enable && cfg.enable) {
    # Use platform-appropriate wallpaper manager
    home.packages = if isDarwin then [
      gowallWrapper  # Use gowall on macOS (gowall is installed via home/packages.nix)
    ] else [
      fzfWallpaperSelector  # Use fzf-based selector on Linux
      pkgs.imagemagick
      pkgs.findutils
    ];

    home.shellAliases = {
      wp = "wallpaper";
    };
  };
}
