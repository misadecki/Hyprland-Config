#!/usr/bin/env bash

FLAG_FILE="/tmp/hypr_theme_state"

if [ ! -f "$FLAG_FILE" ]; then
    echo "dark" > "$FLAG_FILE"
fi

CURRENT_STATE=$(cat "$FLAG_FILE")

if [ "$CURRENT_STATE" = "dark" ]; then
    # ==========================================
    # PRZEŁĄCZANIE NA JASNY MOTYW
    # ==========================================
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
    
    ln -sf ~/.config/kitty/light-theme.conf ~/.config/kitty/current-theme.conf
    ln -sf ~/.config/waybar/colors-light.css ~/.config/waybar/colors-current.css
    
    # Pozwalamy Kitty zareagować na gsettings z GTK, a następnie nadpisujemy to własnym wczytaniem
    sleep 0.2
    touch ~/.config/kitty/kitty.conf
    killall -SIGUSR1 kitty
    killall -SIGUSR2 waybar
    
    hyprshade off
    echo "light" > "$FLAG_FILE"
else
    # ==========================================
    # PRZEŁĄCZANIE NA CIEMNY MOTYW
    # ==========================================
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
    
    ln -sf ~/.config/kitty/dark-theme.conf ~/.config/kitty/current-theme.conf
    ln -sf ~/.config/waybar/colors-dark.css ~/.config/waybar/colors-current.css
    # Analogiczne opóźnienie, które zapobiega ignorowaniu sygnału przez Kitty w ciemnym trybie
    sleep 0.2
    touch ~/.config/kitty/kitty.conf
    killall -SIGUSR1 kitty
    killall -SIGUSR2 waybar

    hyprshade on ~/.config/hypr/shaders/vibrance.glsl
    echo "dark" > "$FLAG_FILE"
fi
