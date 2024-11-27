#!/usr/bin/env bash

sketchybar --add item volume right \
           --set volume \
                 update_freq=5 \
                 script="$HOME/.config/sketchybar/scripts/volume.sh" \
                 click_script="open -a 'System Settings' -n"