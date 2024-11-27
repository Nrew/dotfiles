#!/usr/bin/env bash

sketchybar --add item wifi right \
           --set wifi \
                 update_freq=30 \
                 script="$HOME/.config/sketchybar/scripts/wifi.sh" \
                 click_script="open -a 'System Settings' -n && open 'x-apple.systempreferences:com.apple.preference.network'"