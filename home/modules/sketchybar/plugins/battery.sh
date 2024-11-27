#!/usr/bin/env bash

sketchybar --add item battery.icon right \
           --set battery.icon \
                 update_freq=120 \
                 script="$HOME/.config/sketchybar/scripts/battery.sh" \
                 click_script="pmset -g batt | grep -Eo '\d+%' | cat"
