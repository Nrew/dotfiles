{
  home.file.".local/bin/change_wallpaper".source = pkgs.writeShellScriptBin "change_wallpaper" ''
    #!/bin/bash

    # ────────────────────────────────────────────────────────────────
    # Variables and Argument Validation
    # ────────────────────────────────────────────────────────────────
    WALLPAPER="$1"
    if [ -z "$WALLPAPER" ]; then
      echo "Usage: change_wallpaper <path-to-wallpaper>"
      exit 1
    fi

    if [ ! -f "$WALLPAPER" ]; then
      echo "Error: Wallpaper file does not exist: $WALLPAPER"
      exit 1
    fi

    echo "Setting wallpaper to: $WALLPAPER"

    # ────────────────────────────────────────────────────────────────
    # Set macOS Wallpaper
    # ────────────────────────────────────────────────────────────────
    osascript -e "tell application \\"System Events\\" to set picture of every desktop to \\"$WALLPAPER\\""

    # ────────────────────────────────────────────────────────────────
    # Generate Pywal Theme
    # ────────────────────────────────────────────────────────────────
    wal -i "$WALLPAPER" --saturate 0.8 --backend colorz

    # ────────────────────────────────────────────────────────────────
    # Reload Application Themes
    # ────────────────────────────────────────────────────────────────

    # Kitty: Reload colors
    if command -v kitty >/dev/null; then
      pkill -USR1 kitty
      echo "Reloaded Kitty colors"
    fi

    # Tmux: Reload colors
    if command -v tmux >/dev/null; then
      tmux source-file ~/.cache/wal/colors-tmux.conf
      echo "Reloaded Tmux colors"
    fi

    # SketchyBar: Reload
    if command -v sketchybar >/dev/null; then
      osascript -e 'tell application "SketchyBar" to reload'
      echo "Reloaded SketchyBar"
    fi

    # Spicetify: Apply Pywal theme
    if command -v spicetify >/dev/null; then
      spicetify apply
      echo "Updated Spicetify theme"
    fi

    # ────────────────────────────────────────────────────────────────
    # Completion Message
    # ────────────────────────────────────────────────────────────────
    echo "Theme updated based on wallpaper: $WALLPAPER"
  '';
  
  # Ensure the script is executable
  home.sessionVariables.PATH = "${config.home.homeDirectory}/.local/bin:${pkgs.coreutils}/bin:${pkgs.python3}/bin:$PATH";
}
