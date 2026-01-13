#!/bin/bash

# Plik do przechowywania stanu (1 = włączony, 0 = wyłączony)
STATUS_FILE="/tmp/touchpad_status"
DEVICE="synps/2-synaptics-touchpad"

# Jeśli plik nie istnieje, zakładamy, że touchpad jest włączony (domyślny stan)
if [ ! -f "$STATUS_FILE" ]; then
    echo 1 > "$STATUS_FILE"
fi

# Odczytujemy aktualny stan
STATUS=$(cat "$STATUS_FILE")

if [ "$STATUS" -eq 1 ]; then
    # -- AKCJA: WYŁĄCZ --
    hyprctl keyword "device[$DEVICE]:enabled" false
    echo 0 > "$STATUS_FILE"
    
    # Powiadomienie (zastępujące poprzednie)
    notify-send -u low -t 1500 \
        -h string:x-canonical-private-synchronous:touchpad_toggle \
        -h int:transient:1 \
        "Touchpad" "Disabled"
else
    # -- AKCJA: WŁĄCZ --
    hyprctl keyword "device[$DEVICE]:enabled" true
    echo 1 > "$STATUS_FILE"
    
    # Powiadomienie (zastępujące poprzednie)
    notify-send -u low -t 1500 \
        -h string:x-canonical-private-synchronous:touchpad_toggle \
        -h int:transient:1 \
        "Touchpad" "Enabled"
fi
