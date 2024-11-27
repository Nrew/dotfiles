#!/usr/bin/env bash

sketchybar --add item clock.time right \
           --add item clock.date right \
           --set clock.time \
                 update_freq=30 \
                 script="$HOME/.config/sketchybar/scripts/clock.sh" \
                 click_script="open -a Calendar" \
           --set clock.date \
                 update_freq=30 \
                 script="$HOME/.config/sketchybar/scripts/clock.sh"
