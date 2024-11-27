#!/usr/bin/env bash

sketchybar --add item music center \
           --set music \
                 update_freq=5 \
                 script="$HOME/.config/sketchybar/scripts/music.sh" \
                 click_script="open -a Spotify"