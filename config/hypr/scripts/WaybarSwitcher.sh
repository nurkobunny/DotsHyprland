#!/bin/bash

CONFIG_DIR="$HOME/.config/waybar/configs"
MAIN_CONFIG="$HOME/.config/waybar/config"

if [ ! -d "$CONFIG_DIR" ]; then
    notify-send "Error" "Directory $CONFIG_DIR not found"
    exit 1
fi

selected=$(ls "$CONFIG_DIR" | rofi -dmenu -i -p "Layout:")

if [ -n "$selected" ]; then
    cp "$CONFIG_DIR/$selected" "$MAIN_CONFIG"
    
    killall waybar
    waybar &
    
    notify-send "Waybar" "Layout changed to $selected"
fi
