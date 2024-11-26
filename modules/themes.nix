{ config, pkgs, ... }:

{
  # ────────────────────────────────────────────────────────────────
  # System Packages
  # ────────────────────────────────────────────────────────────────

  environment.systemPackages = with pkgs; [
    wal            # Pywal for color generation
    feh            # Wallpaper setter (you can replace with another tool)
    jq             # JSON processor for parsing Pywal colors
  ];

  # ────────────────────────────────────────────────────────────────
  # Theme Update Script
  # ────────────────────────────────────────────────────────────────

  environment.etc."change_wallpaper.sh".source = "${pkgs.writeShellScriptBin "change_wallpaper" ''
    #!/bin/bash

    WALLPAPER="$1"
    if [ ! -f "$WALLPAPER" ]; then
      echo "Error: Wallpaper file does not exist: $WALLPAPER"
      exit 1
    fi

    # Set wallpaper
    osascript -e "tell application \\"System Events\\" to set picture of every desktop to \\"$WALLPAPER\\""

    # Generate Pywal theme
    wal -i "$WALLPAPER"

    # Reload Kitty colors
    pkill -USR1 kitty

    # Reload Tmux colors
    tmux source-file ~/.cache/wal/colors-tmux.conf

    # Reload SketchyBar
    osascript -e 'tell application "SketchyBar" to reload'

    # Reload BetterDiscord theme
    # python ~/.pywal-discord/pywal-discord.py

    echo "Theme updated based on wallpaper: $WALLPAPER"
  ''}";
}
