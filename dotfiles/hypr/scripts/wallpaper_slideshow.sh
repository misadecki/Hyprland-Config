#!/bin/bash
DIR="$HOME/Pictures/Wallpaper"
INTERVAL=7200 #2h

trap 'kill $!; wait $!' USR1

while true; do
    sleep $INTERVAL &
    wait $!
    WALLPAPER=$(find "$DIR" -type f | shuf -n 1)
    awww img "$WALLPAPER" \
    --transition-type wipe \
    --transition-angle 30 \
    --transition-duration 2 \
    --transition-fps 60
done
