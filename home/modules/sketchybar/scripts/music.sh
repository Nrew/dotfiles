#!/usr/bin/env bash

# Default Spotify commands using osascript
PLAYER_STATE=$(osascript -e 'tell application "Spotify" to player state as string')
TRACK_NAME=$(osascript -e 'tell application "Spotify" to name of current track as string')
ARTIST_NAME=$(osascript -e 'tell application "Spotify" to artist of current track as string')

# Cache the data to prevent unnecessary updates
CACHE_DIR="$HOME/.cache/sketchybar/spotify"
mkdir -p "$CACHE_DIR"

# Only update if there's a change
if [ "$PLAYER_STATE" = "playing" ]; then
  CURRENT_DATA="$TRACK_NAME - $ARTIST_NAME"
  CACHED_DATA=$(cat "$CACHE_DIR/current" 2>/dev/null || echo "")
  
  if [ "$CURRENT_DATA" != "$CACHED_DATA" ]; then
    echo "$CURRENT_DATA" > "$CACHE_DIR/current"
    sketchybar --set $NAME icon="󰎈" label="$TRACK_NAME - $ARTIST_NAME"
  fi
else
  if [ -f "$CACHE_DIR/current" ]; then
    rm "$CACHE_DIR/current"
    sketchybar --set $NAME icon="󰎊" label="Not Playing"
  fi
fi
