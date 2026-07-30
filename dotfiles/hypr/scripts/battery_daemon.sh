#!/bin/bash

LOW_LEVEL=20
CRIT_LEVEL=10
SOUND_PATH="/usr/share/sounds/freedesktop/stereo/dialog-warning.oga"

last_notified=0

while true; do
    BAT_PATH=$(ls -d /sys/class/power_supply/BAT* | head -n 1)
    PERCENT=$(cat "$BAT_PATH/capacity")
    STATUS=$(cat "$BAT_PATH/status")

    if [ "$STATUS" = "Discharging" ]; then
        if [ "$PERCENT" -le "$CRIT_LEVEL" ] && [ "$last_notified" -ne "$CRIT_LEVEL" ]; then
            notify-send -u critical -i battery-empty "Critical battery level:
            $PERCENT%" "Plug in charger immediately!"
            pw-play "$SOUND_PATH"
            last_notified=$CRIT_LEVEL
        elif [ "$PERCENT" -le "$LOW_LEVEL" ] && [ "$PERCENT" -gt "$CRIT_LEVEL" ] && [ "$last_notified" -ne "$LOW_LEVEL" ]; then
            notify-send -u normal -i battery-low "Battery low: $PERCENT%" "Plug in charger."
            pw-play "$SOUND_PATH"
            last_notified=$LOW_LEVEL
        fi
    else
        last_notified=0
    fi

    sleep 60
done
