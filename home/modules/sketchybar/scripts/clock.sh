#!/usr/bin/env bash

# Clock icon based on time of day
CLOCK_ICONS=("" "" "" "")
CURRENT_HOUR=$(date '+%H')

# Select icon based on time of day
if ((CURRENT_HOUR >= 6 && CURRENT_HOUR < 12)); then
  ICON=${CLOCK_ICONS[0]}  # Morning
elif ((CURRENT_HOUR >= 12 && CURRENT_HOUR < 17)); then
  ICON=${CLOCK_ICONS[1]}  # Afternoon
elif ((CURRENT_HOUR >= 17 && CURRENT_HOUR < 21)); then
  ICON=${CLOCK_ICONS[2]}  # Evening
else
  ICON=${CLOCK_ICONS[3]}  # Night
fi

# Format the time and date
TIME=$(date '+%H:%M')
DATE=$(date '+%a %d %b')

# Update the sketchybar items
sketchybar --set $NAME.time label="$TIME" icon="$ICON"
sketchybar --set $NAME.date label="$DATE"
