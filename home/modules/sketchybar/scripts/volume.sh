#!/usr/bin/env bash

# Get current volume and mute status
VOLUME=$(osascript -e 'output volume of (get volume settings)')
MUTED=$(osascript -e 'output muted of (get volume settings)')

# Volume icon based on level and mute status
if [[ $MUTED == "true" ]]; then
  ICON="󰝟"
else
  case ${VOLUME} in
    100) ICON="󰕾";;
    9[0-9]) ICON="󰕾";;
    8[0-9]) ICON="󰕾";;
    7[0-9]) ICON="󰖀";;
    6[0-9]) ICON="󰖀";;
    5[0-9]) ICON="󰖀";;
    4[0-9]) ICON="󰕿";;
    3[0-9]) ICON="󰕿";;
    2[0-9]) ICON="󰕿";;
    1[0-9]) ICON="󰕾";;
    [0-9]) ICON="󰕿";;
    *) ICON="󰖁";;
  esac
fi

# Only update if there's a change
sketchybar --set $NAME icon="$ICON" label="${VOLUME}%"