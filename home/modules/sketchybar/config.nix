{ config, pkgs, ... }:

{
  imports = [ ./sketchybar.nix ]; 

  services.sketchybar = {
    enable = true;
    
    extraConfig = ''
      # ────────────────────────────────────────────────────────────────
      # Dynamic Colors from Pywal
      # ────────────────────────────────────────────────────────────────

      # Check if Pywal colors exist, otherwise use fallbacks
      if [ -f ~/.cache/wal/colors.sh ]; then
        source ~/.cache/wal/colors.sh
      else
        BACKGROUND="#1e1e2e"  # Default background color
        FOREGROUND="#cdd6f4"  # Default foreground color
        COLOR1="#89b4fa"      # Default icon color
      fi

      # Apply colors to SketchyBar
      bar_color=$BACKGROUND
      label_color=$FOREGROUND
      icon_color=$COLOR1

      # ────────────────────────────────────────────────────────────────
      # Bar Configuration
      # ────────────────────────────────────────────────────────────────

      sketchybar --bar height=30 \
                      position=top \
                      padding_left=5 \
                      padding_right=5 \
                      color=$bar_color \
                      shadow=on

      # ────────────────────────────────────────────────────────────────
      # Font Configuration
      # ────────────────────────────────────────────────────────────────

      sketchybar --default label.font="JetBrainsMono Nerd Font:Bold:12.0" \
                          icon.font="JetBrainsMono Nerd Font:Bold:12.0"

      # ────────────────────────────────────────────────────────────────
      # Items Configuration
      # ────────────────────────────────────────────────────────────────

      # Battery
      sketchybar --add item battery right \
                --set battery script="pmset -g batt | grep -Eo '\\d+%' | cut -d% -f1" \
                            label.drawing=off \
                            icon.drawing=on \
                            icon.color=$COLOR1

      # CPU Usage
      sketchybar --add item cpu right \
                --set cpu script="top -l 1 | grep 'CPU usage' | awk '{print \$3}'" \
                         label.drawing=off \
                         icon.drawing=on \
                         icon.color=$COLOR1

      # Current Application
      sketchybar --add item front_app left \
                --set front_app script="osascript -e 'tell application \"System Events\" to get name of first application process whose frontmost is true'" \
                              label.drawing=on \
                              icon.drawing=off \
                              label.color=$COLOR1

      # Clock
      sketchybar --add item clock right \
                --set clock script="date '+%H:%M:%S'" \
                           update_freq=1 \
                           label.drawing=on \
                           label.color=$COLOR1

      # ────────────────────────────────────────────────────────────────
      # Final Settings
      # ────────────────────────────────────────────────────────────────

      sketchybar --update
    '';
  };
}