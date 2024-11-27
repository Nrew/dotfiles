#!/usr/bin/env bash

# Get WiFi information
WIFI=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I)
SSID=$(echo "$WIFI" | grep -o "SSID: .*" | sed 's/^SSID: //')
SPEED=$(echo "$WIFI" | grep -o "lastTxRate: .*" | sed 's/^lastTxRate: //')

# Check if connected to WiFi
if [ "$SSID" = "" ]; then
  sketchybar --set $NAME icon="󰖪" label="Disconnected"
else
  # Signal strength icon based on TX rate
  if [ "$SPEED" -gt 300 ]; then
    ICON="󰖩"
  elif [ "$SPEED" -gt 100 ]; then
    ICON="󰖧"
  elif [ "$SPEED" -gt 50 ]; then
    ICON="󰖦"
  else
    ICON="󰖪"
  fi
  
  sketchybar --set $NAME icon="$ICON" label="$SSID"
fi