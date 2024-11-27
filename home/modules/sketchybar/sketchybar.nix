{pkgs, lib, config, ...}:

let
  # Helper function to create scripts
  mkScript = name: content: pkgs.writeShellScriptBin "sb-${name}" ''
    #!${pkgs.bash}/bin/bash
    ${content}
  '';

  scripts = {
    battery = ''
      source "$HOME/.cache/wal/colors.sh"
      
      BATTERY_INFO="$(pmset -g batt)"
      PERCENTAGE=$(echo "$BATTERY_INFO" | grep -Eo "[0-9]+%" | cut -d% -f1)
      CHARGING=$(echo "$BATTERY_INFO" | grep 'AC Power')
      
      if [ "$PERCENTAGE" = "" ]; then
        exit 0
      fi
      
      case "$PERCENTAGE" in
        100) ICON="" ;;
        9[0-9]) ICON="" ;;
        [6-8][0-9]) ICON="" ;;
        [3-5][0-9]) ICON="" ;;
        [1-2][0-9]) ICON="" ;;
        *) ICON=""
      esac
      
      if [[ "$CHARGING" != "" ]]; then
        ICON=""
      fi
      
      sketchybar --set "$NAME" icon="$ICON" label="$PERCENTAGE%"
    '';

    wifi = ''
      source "$HOME/.cache/wal/colors.sh"
      
      WIFI=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I)
      SSID=$(echo "$WIFI" | grep -o "SSID: .*" | sed 's/^SSID: //')
      
      if [ "$SSID" = "" ]; then
        sketchybar --set "$NAME" icon="" label="Disconnected"
      else
        sketchybar --set "$NAME" icon="" label="$SSID"
      fi
    '';

    volume = ''
      source "$HOME/.cache/wal/colors.sh"
      
      VOLUME=$(osascript -e "output volume of (get volume settings)")
      MUTED=$(osascript -e "output muted of (get volume settings)")
      
      if [ "$MUTED" = "true" ]; then
        ICON="婢"
      else
        case "$VOLUME" in
          100) ICON="" ;;
          9[0-9]) ICON="" ;;
          [6-8][0-9]) ICON="" ;;
          [3-5][0-9]) ICON="" ;;
          [1-2][0-9]) ICON="" ;;
          *) ICON=""
        esac
      fi
      
      sketchybar --set "$NAME" icon="$ICON" label="$VOLUME%"
    '';

    spotify = ''
      source "$HOME/.cache/wal/colors.sh"
      
      # Default Spotify commands using osascript
      PLAYER_STATE=$(osascript -e 'tell application "Spotify" to player state as string' 2>/dev/null)
      TRACK_NAME=$(osascript -e 'tell application "Spotify" to name of current track as string' 2>/dev/null)
      ARTIST_NAME=$(osascript -e 'tell application "Spotify" to artist of current track as string' 2>/dev/null)
      
      # Cache the data to prevent unnecessary updates
      CACHE_DIR="$HOME/.cache/sketchybar/spotify"
      mkdir -p "$CACHE_DIR"
      
      # Only update if there's a change
      if [ "$PLAYER_STATE" = "playing" ]; then
        CURRENT_DATA="$TRACK_NAME - $ARTIST_NAME"
        CACHED_DATA=$(cat "$CACHE_DIR/current" 2>/dev/null || echo "")
        
        if [ "$CURRENT_DATA" != "$CACHED_DATA" ]; then
          echo "$CURRENT_DATA" > "$CACHE_DIR/current"
          sketchybar --set "$NAME" icon="󰎈" label="$TRACK_NAME - $ARTIST_NAME"
        fi
      else
        if [ -f "$CACHE_DIR/current" ]; then
          rm "$CACHE_DIR/current"
          sketchybar --set "$NAME" icon="󰎊" label="Not Playing"
        fi
      fi
    '';

    spaces = ''
      source "$HOME/.cache/wal/colors.sh"
      
      SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
      
      for i in "''${!SPACE_ICONS[@]}"
      do
        sid=$((i+1))
        sketchybar --add space "space.$sid" left \
                   --set "space.$sid" associated_space="$sid" \
                                    icon="''${SPACE_ICONS[$i]}" \
                                    icon.padding_left=8 \
                                    icon.padding_right=8 \
                                    background.padding_left=5 \
                                    background.padding_right=5 \
                                    background.color="$BAR_COLOR" \
                                    background.border_color="$BAR_BORDER_COLOR" \
                                    background.border_width=2 \
                                    background.drawing=off \
                                    label.drawing=off \
                                    script="$HOME/.config/sketchybar/scripts/space.sh" \
                                    click_script="aerospace space $sid"
      done
    '';

    space = ''
      source "$HOME/.cache/wal/colors.sh"
      
      SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
      CURRENT_SPACE=$(aerospace space current)
      
      for i in "''${!SPACE_ICONS[@]}"
      do
        sid=$((i+1))
        
        if [ "$sid" = "$CURRENT_SPACE" ]; then
          sketchybar --set "space.$sid" \
                     background.drawing=on \
                     icon.color="$BAR_COLOR" \
                     background.color="$ICON_COLOR"
        else
          sketchybar --set "space.$sid" \
                     background.drawing=off \
                     icon.color="$ICON_COLOR" \
                     background.color="$BAR_COLOR"
        fi
      done
    '';

    clock = ''
      source "$HOME/.cache/wal/colors.sh"
      
      CLOCK_ICONS=("" "" "" "")
      CURRENT_HOUR=$(date '+%H')
      
      if ((CURRENT_HOUR >= 6 && CURRENT_HOUR < 12)); then
        ICON="''${CLOCK_ICONS[0]}"
      elif ((CURRENT_HOUR >= 12 && CURRENT_HOUR < 17)); then
        ICON="''${CLOCK_ICONS[1]}"
      elif ((CURRENT_HOUR >= 17 && CURRENT_HOUR < 21)); then
        ICON="''${CLOCK_ICONS[2]}"
      else
        ICON="''${CLOCK_ICONS[3]}"
      fi
      
      TIME=$(date '+%H:%M')
      DATE=$(date '+%a %d %b')
      
      sketchybar --set "$NAME.time" label="$TIME" icon="$ICON"
      sketchybar --set "$NAME.date" label="$DATE"
    '';
  };

  sketchybarPackages = with pkgs; [
    sketchybar
    jq
    coreutils
    gnugrep
  ] ++ (lib.mapAttrsToList (name: content: mkScript name content) scripts)
    ++ [(pkgs.writeShellScriptBin "sketchybar-reload" ''
      #!${pkgs.bash}/bin/bash
      source "$HOME/.cache/wal/colors-sketchybar.sh"
      sketchybar --remove '/.*/'
      source "$HOME/.config/sketchybar/sketchybarrc"
    '')];

in {
  home.packages = sketchybarPackages;

  xdg.configFile = {
    "sketchybar/scripts" = {
      recursive = true;
      executable = true;
      text = lib.concatStrings (lib.mapAttrsToList (name: content: ''
        #!${pkgs.bash}/bin/bash
        ${content}
      '') scripts);
    };
  };

  home.file.".config/sketchybar/sketchybarrc" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Load colors from pywal
      source "$HOME/.cache/wal/colors.sh"

      # Color Definitions
      export BAR_COLOR="0xff''${background:1}"
      export BAR_BORDER_COLOR="0xff''${color4:1}"
      export ICON_COLOR="0xff''${color4:1}"
      export LABEL_COLOR="0xff''${foreground:1}"
      export POPUP_BACKGROUND_COLOR="0xff''${background:1}"
      export POPUP_BORDER_COLOR="0xff''${color4:1}"
      export SHADOW_COLOR="0xff''${background:1}"

      # Bar Properties
      sketchybar --bar \
                 height=32 \
                 blur_radius=0 \
                 position=top \
                 sticky=on \
                 padding_left=10 \
                 padding_right=10 \
                 color=$BAR_COLOR \
                 border_width=2 \
                 border_color=$BAR_BORDER_COLOR \
                 shadow=off \
                 topmost=window

      # Global Defaults
      sketchybar --default \
                 background.color=$BAR_COLOR \
                 background.border_color=$BAR_BORDER_COLOR \
                 icon.color=$ICON_COLOR \
                 icon.font="JetBrainsMono Nerd Font:Bold:14.0" \
                 icon.padding_left=5 \
                 icon.padding_right=5 \
                 label.color=$LABEL_COLOR \
                 label.font="JetBrainsMono Nerd Font:Bold:13.0" \
                 label.padding_left=5 \
                 label.padding_right=5 \
                 popup.background.color=$POPUP_BACKGROUND_COLOR \
                 popup.background.border_color=$POPUP_BORDER_COLOR \
                 popup.background.border_width=2 \
                 popup.background.corner_radius=6 \
                 popup.background.shadow.drawing=off

      # Left
      source "$HOME/.config/sketchybar/scripts/spaces.sh"
      
      # Center
      source "$HOME/.config/sketchybar/scripts/spotify.sh"
      
      # Right
      source "$HOME/.config/sketchybar/scripts/clock.sh"
      source "$HOME/.config/sketchybar/scripts/wifi.sh"
      source "$HOME/.config/sketchybar/scripts/battery.sh"
      source "$HOME/.config/sketchybar/scripts/volume.sh"

      # Finalizing Setup
      sketchybar --update

      # Start Event Loop for Updates
      sketchybar --bar event=on
    '';
  };

  # ────────────────────────────────────────────────────────────────
  # Service Configuration
  # ────────────────────────────────────────────────────────────────
  
  launchd.agents.sketchybar = {
    enable = true;
    config = {
      ProgramArguments = [ "${pkgs.sketchybar}/bin/sketchybar" ];
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}