{ config, pkgs, lib, ... }:

let
  # ────────────────────────────────────────────────────────────────
  # Wallpaper Detection Script
  # ────────────────────────────────────────────────────────────────
  getCurrentWallpaper = pkgs.writeShellScriptBin "get-current-wallpaper" ''
    #!/usr/bin/env bash
    osascript -e 'tell app "System Events" to get picture of current desktop' 2>/dev/null
  '';

  # ────────────────────────────────────────────────────────────────
  # Theme Update Script
  # ────────────────────────────────────────────────────────────────
  themeScript = pkgs.writeShellScriptBin "update-theme" ''
    #!/usr/bin/env bash
    set -euo pipefail

    # ────────────────────────────────────────────────────────────────
    # Utility Functions
    # ────────────────────────────────────────────────────────────────
    
    function log() {
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
    }

    function check_dependencies() {
      local missing_deps=()
      local deps=("convert" "wal")
      
      for dep in "''${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
          missing_deps+=("$dep")
        fi
      done
      
      if [ ''${#missing_deps[@]} -ne 0 ]; then
        log "Error: Missing dependencies: ''${missing_deps[*]}"
        exit 1
      fi
    }

    # ────────────────────────────────────────────────────────────────
    # Wallpaper Management
    # ────────────────────────────────────────────────────────────────

    function get_current_wallpaper() {
      local wallpaper
      wallpaper=$(${getCurrentWallpaper}/bin/get-current-wallpaper)
      
      if [ -f "$wallpaper" ]; then
        echo "$wallpaper"
        return 0
      else
        log "Error: Could not detect current wallpaper"
        return 1
      fi
    }

    # ────────────────────────────────────────────────────────────────
    # Color Scheme Generation
    # ────────────────────────────────────────────────────────────────

    function generate_colorscheme() {
      local wallpaper="$1"
      ${pkgs.pywal}/bin/wal -i "$wallpaper" --saturate 0.7 -n
      if [ $? -eq 0 ]; then
        log "Color scheme generated successfully"
        
        # Ensure cache directory exists
        mkdir -p "$HOME/.cache/wal"
        
        # Copy color scheme to a predictable location
        cp -r "$HOME/.cache/wal/colors"* "$HOME/.cache/wal/"
      else
        log "Failed to generate color scheme"
        return 1
      fi
    }

    # ────────────────────────────────────────────────────────────────
    # Application Updates
    # ────────────────────────────────────────────────────────────────

    function reload_applications() {
      # Kitty Terminal
      if pgrep -x "kitty" >/dev/null; then
        killall -USR1 kitty
        log "Kitty terminal reloaded"
      fi

      # Neovim (if running with neovim-remote)
      if command -v nvr >/dev/null 2>&1; then
        for server in $(nvr --serverlist); do
          nvr --servername "$server" -cc 'colorscheme wal'
        done
        log "Neovim instances reloaded"
      fi

      # Tmux
      if command -v tmux >/dev/null 2>&1 && tmux list-sessions &>/dev/null; then
        tmux source-file "$HOME/.cache/wal/colors-tmux.conf"
        log "Tmux configuration reloaded"
      fi

      # SketchyBar
      if command -v sketchybar >/dev/null 2>&1; then
        sketchybar --reload
        log "SketchyBar reloaded"
      fi
    }

    # ────────────────────────────────────────────────────────────────
    # Main Execution
    # ────────────────────────────────────────────────────────────────
    
    check_dependencies

    # Get current wallpaper path
    WALLPAPER=$(get_current_wallpaper)
    if [ $? -ne 0 ]; then
      exit 1
    fi

    log "Detected current wallpaper: $WALLPAPER"

    # Generate and apply color scheme
    generate_colorscheme "$WALLPAPER"
    if [ $? -eq 0 ]; then
      reload_applications
      log "Theme update complete!"
    fi
  '';

  # ────────────────────────────────────────────────────────────────
  # Wallpaper Setting Script
  # ────────────────────────────────────────────────────────────────
  setWallpaperScript = pkgs.writeShellScriptBin "set-wallpaper" ''
    #!/usr/bin/env bash
    set -euo pipefail
    
    # ────────────────────────────────────────────────────────────────
    # Input Validation
    # ────────────────────────────────────────────────────────────────
    
    if [ $# -ne 1 ]; then
      echo "Usage: set-wallpaper <path-to-wallpaper>"
      exit 1
    fi
    
    WALLPAPER="$1"
    
    if [ ! -f "$WALLPAPER" ]; then
      echo "Error: Wallpaper file does not exist: $WALLPAPER"
      exit 1
    fi
    
    # ────────────────────────────────────────────────────────────────
    # Wallpaper and Theme Application
    # ────────────────────────────────────────────────────────────────
    
    # Set the wallpaper using macOS native command
    osascript -e "tell application \"System Events\" to set picture of every desktop to \"$WALLPAPER\""
    
    # Update the theme
    ${themeScript}/bin/update-theme
  '';

in
{
  # ────────────────────────────────────────────────────────────────
  # Package Installation
  # ────────────────────────────────────────────────────────────────
  home.packages = [
    getCurrentWallpaper
    themeScript
    setWallpaperScript
  ];

  # ────────────────────────────────────────────────────────────────
  # Theme Initialization
  # ────────────────────────────────────────────────────────────────
  home.activation.initializeTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${themeScript}/bin/update-theme
  '';

  # ────────────────────────────────────────────────────────────────
  # Shell Integration
  # ────────────────────────────────────────────────────────────────
  programs.zsh.shellAliases = {
    "set-wallpaper" = "${setWallpaperScript}/bin/set-wallpaper";
    "update-theme" = "${themeScript}/bin/update-theme";
  };
}