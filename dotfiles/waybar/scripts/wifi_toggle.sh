#!/usr/bin/env bash

STATE_FILE="/tmp/waybar_wifi_state"

# Jeśli plik nie istnieje, zacznij od stanu 0
if [ ! -f "$STATE_FILE" ]; then
    echo "0" > "$STATE_FILE"
fi

# Tryb przełączania (wywoływany kliknięciem w Waybarze)
if [ "$1" == "toggle" ]; then
    STATE=$(cat "$STATE_FILE")
    # Zwiększ o 1, wróć do 0 po osiągnięciu 3 (0 -> 1 -> 2 -> 0)
    NEW_STATE=$(( (STATE + 1) % 3 ))
    echo "$NEW_STATE" > "$STATE_FILE"
    
    # Wymuś natychmiastowe odświeżenie modułu w Waybarze (sygnał 9)
    pkill -SIGRTMIN+9 waybar
    exit 0
fi

# Tryb wyświetlania (uruchamiany domyślnie przez Waybara)
STATE=$(cat "$STATE_FILE")

# Pobieranie danych (wymaga NetworkManager / nmcli)
WIFI_INFO=$(nmcli -t -f active,ssid,signal dev wifi | grep '^yes')

if [ -z "$WIFI_INFO" ]; then
    echo '{"text": "No signal ⚠ ", "tooltip": "Disconnected"}'
    exit 0
fi

SSID=$(echo "$WIFI_INFO" | cut -d: -f2)
SIGNAL=$(echo "$WIFI_INFO" | cut -d: -f3)
IP=$(ip -4 -br addr show | grep UP | awk '{print $3}' | cut -d/ -f1 | head -n 1)

if [ "$STATE" -eq 0 ]; then
    TEXT="${IP} 󰈁"
elif [ "$STATE" -eq 1 ]; then
    TEXT="${SSID}  "
else
    TEXT="${SIGNAL}%  "
fi

# Zwrócenie danych w formacie JSON zrozumiałym dla Waybara
echo "{\"text\": \"$TEXT\", \"tooltip\": \"Click to change view\"}"
