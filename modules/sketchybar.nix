{ config, pkgs, ... }:

{
  # Enable SketchyBar service
  services.sketchybar = {
    enable = true;

    # Include additional SketchyBar configurations
    extraConfig = ''
      # ────────────────────────────────────────────────────────────────
      # Dynamic Colors from Pywal
      # ────────────────────────────────────────────────────────────────

      # Load Pywal colors
      source ~/.cache/wal/colors.sh

      # Set bar colors using Pywal colors
      bar_color=${BACKGROUND}           # Pywal background color
      label_color=${FOREGROUND}         # Pywal foreground color
      icon_color=${COLOR1}              # Example: Pywal's first accent color

      # ────────────────────────────────────────────────────────────────
      # Bar Configuration
      # ────────────────────────────────────────────────────────────────

      bar_height=30                     # Set the bar height
      bar_padding_left=5                # Padding on the left
      bar_padding_right=5               # Padding on the right
      bar_position=top                  # Set bar position: top or bottom

      # Enable shadow behind the bar
      bar_shadow=true

      # ────────────────────────────────────────────────────────────────
      # Icon and Label Font
      # ────────────────────────────────────────────────────────────────

      label.font="JetBrainsMono Nerd Font:Bold:12.0"
      icon.font="JetBrainsMono Nerd Font:Bold:12.0"

      # ────────────────────────────────────────────────────────────────
      # Items (Battery, CPU, Apps, etc.)
      # ────────────────────────────────────────────────────────────────

      # Battery
      sketchybar --add item battery right
      sketchybar --set battery script="pmset -g batt | grep -Eo '\\d+%' | cut -d% -f1"
                  label.drawing=off
                  icon.drawing=on
                  icon.color=$COLOR2

      # CPU Usage
      sketchybar --add item cpu right
      sketchybar --set cpu script="top -l 1 | grep 'CPU usage' | awk '{print $3}'"
                 label.drawing=off
                 icon.drawing=on
                 icon.color=$COLOR3

      # Current Application
      sketchybar --add item front_app left
      sketchybar --set front_app script="osascript -e 'tell application \"System Events\" to get name of first application process whose frontmost is true'"
                 label.drawing=on
                 icon.drawing=off
                 label.color=$COLOR4

      # Clock
      sketchybar --add item clock right
      sketchybar --set clock script="date '+%H:%M:%S'"
                 update_freq=1
                 label.drawing=on
                 label.color=$COLOR5

      # ────────────────────────────────────────────────────────────────
      # Final Settings
      # ────────────────────────────────────────────────────────────────

      sketchybar --add event brew_update_interval 900
      sketchybar --add script 'sketchybar --update'
    '';
  };
}
