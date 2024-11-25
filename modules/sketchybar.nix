{ config, pkgs, ... }:

{
  services.sketchybar = {
    enable = true;

    config = ''
      sketchybar --add item cpu right
      sketchybar --set cpu update_freq=5 label.font="JetBrainsMono Nerd Font:Bold:14.0" script="top -l 1 | awk "/CPU usage/ {print $3}"'

      sketchybar --add item battery right
      sketchybar --set battery update_freq=60 script="pmset -g batt | awk "/InternalBattery/ {print $3}"'

      sketchybar --add item spotify left
      sketchybar --set spotify script="~/.config/sketchybar/scripts/spotify.sh"
    '';
  };
}
