{ config, lib, pkgs, palette, ... }:

# Wallpaper management module for nix-darwin
# This module provides a Nix-focused wallpaper selector that:
# - Uses Nix store paths for all utilities (findutils, imagemagick, etc.)
# - Integrates with the theme system for consistent colors
# - Supports multiple image formats (jpg, jpeg, png, webp)
# - Provides interactive selection via fzf with image preview
# - Works seamlessly with kitty terminal's image display capabilities

let
  cfg = config.wallpaper;
  wallpaperDir = config.theme.wallpaperDir;
  currentWallpaper = "${config.xdg.stateHome}/current-wallpaper";

  # Supported image formats
  imageFormats = [ "jpg" "jpeg" "png" "webp" ];
  
  # Helper to build find pattern for image formats
  # This uses Nix's string manipulation instead of shell scripting
  findPattern = lib.concatMapStringsSep " -o " (fmt: "-iname \"*.${fmt}\"") imageFormats;

  wallpaperSelector = pkgs.writeShellScriptBin "wallpaper" ''
    #!/usr/bin/env bash
    set -euo pipefail

    # Configuration
    WALLPAPER_DIR="${wallpaperDir}"
    CURRENT_LINK="${currentWallpaper}"

    # Source theme palette if available
    [ -f ~/.config/theme/palette.sh ] && source ~/.config/theme/palette.sh

    # Validate wallpaper directory exists
    if [ ! -d "$WALLPAPER_DIR" ]; then
      echo "Error: Wallpaper directory not found: $WALLPAPER_DIR" >&2
      echo "Please create the directory or update theme.wallpaperDir in your configuration." >&2
      exit 1
    fi

    # Count wallpapers
    WALLPAPER_COUNT=$(${pkgs.findutils}/bin/find "$WALLPAPER_DIR" -type f \( ${findPattern} \) 2>/dev/null | wc -l | tr -d ' ')

    if [ "$WALLPAPER_COUNT" -eq 0 ]; then
      echo "Error: No wallpapers found in $WALLPAPER_DIR" >&2
      echo "Supported formats: ${lib.concatStringsSep ", " imageFormats}" >&2
      exit 1
    fi

    # Get current wallpaper name if set
    CURRENT_NAME=""
    if [ -L "$CURRENT_LINK" ]; then
      CURRENT_NAME=$(basename "$(readlink "$CURRENT_LINK")" 2>/dev/null || echo "")
    fi

    # Image preview function for fzf
    preview_image() {
      local file="$1"
      
      # Use kitty icat if running in kitty terminal
      if [ -n "''${KITTY_WINDOW_ID:-}" ]; then
        ${pkgs.kitty}/bin/kitten icat \
          --clear \
          --transfer-mode=memory \
          --stdin=no \
          --place=''${FZF_PREVIEW_COLUMNS}x''${FZF_PREVIEW_LINES}@0x0 \
          "$file" 2>/dev/null
      else
        # Fallback to text-based preview
        echo "╔════════════════════════════════════════╗"
        echo "║           Image Preview                ║"
        echo "╚════════════════════════════════════════╝"
        echo "File: $(basename "$file")"
        echo "Size: $(${pkgs.coreutils}/bin/du -h "$file" | cut -f1)"

        # Show dimensions if imagemagick is available
        if ${pkgs.imagemagick}/bin/identify -version &> /dev/null; then
          local dims=$(${pkgs.imagemagick}/bin/identify -format "%wx%h" "$file" 2>/dev/null)
          [ -n "$dims" ] && echo "Dimensions: $dims"
        fi
      fi
    }

    export -f preview_image
    
    # Launch fzf to select wallpaper
    SELECTED=$(${pkgs.findutils}/bin/find "$WALLPAPER_DIR" -type f \( ${findPattern} \) 2>/dev/null | \
      sed "s|$WALLPAPER_DIR/||" | \
      sort | \
      ${pkgs.fzf}/bin/fzf \
        --height=100% \
        --border=rounded \
        --margin=1 \
        --padding=1 \
        --preview="preview_image \"$WALLPAPER_DIR/{}\"" \
        --preview-window=right:60% \
        --prompt="🖼️  " \
        --header="$WALLPAPER_COUNT wallpapers$([ -n "$CURRENT_NAME" ] && echo " • Current: $CURRENT_NAME" || echo "")" \
        --color="fg:''${THEME_TEXT:-${palette.text}},bg:''${THEME_OVERLAY:-${palette.overlay}}" \
        --color="fg+:''${THEME_TEXT:-${palette.text}},bg+:''${THEME_PRIMARY:-${palette.primary}}" \
        --color="info:''${THEME_MUTED:-${palette.muted}},prompt:''${THEME_PRIMARY:-${palette.primary}},pointer:''${THEME_ERROR:-${palette.error}}" \
        --pointer="▶" \
        --marker="✓" \
        --no-scrollbar \
        --bind="ctrl-d:preview-page-down,ctrl-u:preview-page-up") || exit 0
    
    # Exit if no selection made
    [ -z "$SELECTED" ] && exit 0

    # Set the wallpaper
    WALLPAPER_PATH="$WALLPAPER_DIR/$SELECTED"
    
    # Create state directory and symlink
    mkdir -p "$(dirname "$CURRENT_LINK")"
    ln -sf "$WALLPAPER_PATH" "$CURRENT_LINK"

    # Apply wallpaper using macOS System Events
    echo "Setting wallpaper: $SELECTED"
    /usr/bin/osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER_PATH\"" && \
      echo "✅ Wallpaper applied successfully" || \
      echo "⚠️  Warning: Failed to apply wallpaper via System Events"
  '';

in 
{
  options.wallpaper = {
    enable = lib.mkEnableOption "wallpaper management";
  };
  
  config = lib.mkIf (config.theme.enable && cfg.enable) {
    # Assertion to ensure wallpaper directory exists at build time if it's in the repo
    assertions = [
      {
        assertion = lib.hasPrefix "/nix/store" wallpaperDir || 
                   lib.hasPrefix config.home.homeDirectory wallpaperDir;
        message = "wallpaper.wallpaperDir must be either in the Nix store or user's home directory";
      }
    ];

    home.packages = [
      wallpaperSelector
      pkgs.imagemagick  # For image identification
      pkgs.findutils    # For reliable find command
    ];

    home.shellAliases = {
      wp = "wallpaper";
    };
  };
}
