{ config, lib, pkgs, palette, ... }:
let
  cfg = config.wallpaper;
  wallpaperDir = config.theme.wallpaperDir;
  currentWallpaper = "${congig.xdg.stateHome}/current-wallpaper";

  wallpaperSelector = pkgs.writeShellScriptBin "wallpaper" ''
    #!usr/bin/env bash

    WALLPAPER_DIR="${wallpaperDir}"
    CURRENT_LINK="${currentWallpaper}"

    if [ -f ~/.config/theme/palette.sh ]; then
      source ~/.config/theme/palette.sh
    fi

    if [ ! -d "$WALLPAPER_DIR" ]; then
      echo "Wallpaper directory not found: $WALLPAPER_DIR"
      exit 1
    fi

    WALLPAPER_COUNT=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png"\) 2>/dev/null | wc -l | tr -d ' ')

    if [ "$WALLPAPER_COUNT"  -eq 0 ]; then
      echo "No wallpapers found"
      exit 1
    fi

    CURRENT_NAME=""
    if [ -L "$CURRENT_LINK" ]; then
      CURRENT_NAME=$(basename "$(readlink "$CURRENT_LINK")" 2>/dev/null || echo "")
    fi

    preview_image() {
      local file = "$1"
      if [ -n "$KITTY_WINDOW_ID" ]; then
        ${pkgs.kitty}/bin/kitten icat \
          --clear \
          --transfer-mode=memory \
          --stdin=no \
          --place=''${FZF_PREVIEW_COLUMNS}x''${FZF_PREVIEW_LINES}@0x0 \
          "$file" 2>/dev/null
      else
        echo "Image Preview"
        echo "$(basename "$file")"
        echo "$(du -h "$file" | cut -f1)"

        if command -v identify &> /dev/null; then
          local dims=$(identify -format "%wx%h" "$file" 2>/dev/null)
          [ -n "$dims" ] && echo "$dims"
        fi
      fi
    }

    export -f preview_image

    SELECTED=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) 2>/dev/null | \
      sed "s|$WALLPAPER_DIR/||" | \
      sort | \
      ${pkgs.fzf}/bin/fzf \
        --height=100% \
        --border=rounded \
        --margin=1 \
        --padding=1 \
        --preview="preview_image \"$WALLPAPER_DIR/{}\""\
        --preview-window=right:60% \
        --prompt= ""\
        --header="$WALLPAPER_COUNT wallpapers$([ -n "$CURRENT_NAME" ] && echo " * Current: $CURRENT_NAME" || echo "")" \
        --color="fg:''${THEME_TEXT:-#2d2a25},bg:''${THEME_OVERLAY:-#e0dcd3}" \
        --color="fg+:''${THEME_TEXT:-#2d2a25},bg+''${THEME_PRIMARY:-#7c8a9e}" \
        --color="info:''${THEME_MUTED:-#8a857d},prompt:''${THEME_PRIMARY:-#7c8a9e},pointer:''${THEME_ERROR:-#b87d7d}" \
        --pointer=">" \
        --marker="x" \
        --no-scrollbar \
        --bind="ctrl-d:preview-page-down,ctril-u:preview-page-up")

    [ -z "$SELECTED" ] && exit 0

    WALLPAPER_PATH="$WALLPAPER_DIR/$SELECTED"
    mkdir -p "$(dirname "$CURRENT_LINK")"
    ln -sf "$WALLPAPER_PATH "$CURRENT_LINK""

    echo "$SELECTED"
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER_PATH\""
    echo "Done"
  '';

  in 
  {
    options.wallpaper = {
      enable = lib.mkEnableOption "wallpaper management";
    };
    
    config = lib.mkIf (config.theme.enable && cfg.enable) {
      home.packages = [
        wallpaperSelector
        pkgs.imagemagick
      ];

      home.shellAliases = [
        wp = "wallpaper";
      ]
    }
  }
