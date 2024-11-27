#!/usr/bin/env bash

SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

for i in "${!SPACE_ICONS[@]}"
do
  sid=$(($i+1))
  sketchybar --add space space.$sid left \
             --set space.$sid associated_space=$sid \
                              icon=${SPACE_ICONS[i]} \
                              icon.padding_left=8 \
                              icon.padding_right=8 \
                              background.padding_left=5 \
                              background.padding_right=5 \
                              background.color=$BAR_COLOR \
                              background.border_color=$BAR_BORDER_COLOR \
                              background.border_width=2 \
                              background.drawing=off \
                              label.drawing=off \
                              script="$HOME/.config/sketchybar/scripts/space.sh" \
                              click_script="aerospace space $sid"
done