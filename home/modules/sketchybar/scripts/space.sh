#!/usr/bin/env bash

# Space icons (same as in spaces.sh for consistency)
SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

# Get the current space
CURRENT_SPACE=$(aerospace space current)

# Update space appearances
for i in "${!SPACE_ICONS[@]}"; do
  sid=$(($i+1))
  
  if [ "$sid" = "$CURRENT_SPACE" ]; then
    # Current space
    sketchybar --set space.$sid \
               background.drawing=on \
               icon.color=$BAR_COLOR \
               background.color=$ICON_COLOR
  else
    # Inactive space
    sketchybar --set space.$sid \
               background.drawing=off \
               icon.color=$ICON_COLOR \
               background.color=$BAR_COLOR
  fi
done