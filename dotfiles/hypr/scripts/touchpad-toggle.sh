#!/bin/bash

STATUS_FILE="/tmp/touchpad_status"
DEVICE="synps/2-synaptics-touchpad"

if [ ! -f "$STATUS_FILE" ]; then
    echo 1 > "$STATUS_FILE"
fi

STATUS=$(cat "$STATUS_FILE")

if [ "$STATUS" -eq 1 ]; then
  hyprctl eval "hl.device({ name = \"$DEVICE\", enabled = false })"
    echo 0 > "$STATUS_FILE"
    
    notify-send -u low -t 1500 \
        -h string:x-canonical-private-synchronous:touchpad_toggle \
        -h int:transient:1 \
        "Touchpad" "Disabled"
else
  hyprctl eval "hl.device({ name = \"$DEVICE\", enabled = true })"
    echo 1 > "$STATUS_FILE"
    
    notify-send -u low -t 1500 \
        -h string:x-canonical-private-synchronous:touchpad_toggle \
        -h int:transient:1 \
        "Touchpad" "Enabled"
fi
