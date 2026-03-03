#!/bin/bash

declare -A WALL_DIRS
WALL_DIRS["Gruvbox"]="$HOME/Pictures/wallpapers/Dynamic-Wallpapers/GruvBox/"
WALL_DIRS["Catppuccin"]="$HOME/Pictures/wallpapers/Dynamic-Wallpapers/Catppuccin/"
WALL_DIRS["TokyoNight"]="$HOME/Pictures/wallpapers/Dynamic-Wallpapers/TokyoNight/"
WALL_DIRS["Dracula"]="$HOME/Pictures/wallpapers/Dynamic-Wallpapers/Dracula/"
WALL_DIRS["Nord"]="$HOME/Pictures/wallpapers/Dynamic-Wallpapers/Nord/"
WALL_DIRS["GruvboxLight"]="$HOME/Pictures/wallpapers/Dynamic-Wallpapers/GruvBoxLight/"
WALL_DIRS["RosePine"]="$HOME/Pictures/wallpapers/Dynamic-Wallpapers/RosePine/"
WALL_DIRS["RosePineDawn"]="$HOME/Pictures/wallpapers/Dynamic-Wallpapers/RosePineDawn/"
WALL_DIRS["CatppuccinLight"]="$HOME/Pictures/wallpapers/Dynamic-Wallpapers/CatppuccinLight/"
WALL_DIRS["Kanagawa"]="$HOME/Pictures/wallpapers/Dynamic-Wallpapers/Kanagawa/"

ICONS_DIR="$HOME/.config/hypr/icons"

THEME_MENU=""
for theme_name in "${!WALL_DIRS[@]}"; do
    lower_name=$(echo "$theme_name" | tr '[:upper:]' '[:lower:]')
    
    ICON_PATH=$(find "$ICONS_DIR" -maxdepth 1 -type f -regex ".*/${lower_name}\.[^/]*$" | head -n 1)
    
    if [[ -n "$ICON_PATH" ]]; then
        THEME_MENU+="${theme_name}\x0icon\x1f${ICON_PATH}\n"
    else
        THEME_MENU+="${theme_name}\n"
    fi
done

THEME=$(echo -en "$THEME_MENU" | rofi -dmenu -show-icons -p "Select Theme")

[[ -z "$THEME" ]] && exit 0

DIR="${WALL_DIRS[$THEME]}"
[[ ! -d "$DIR" ]] && exit 1

MENU=""
while IFS= read -r file; do
  name=$(basename "$file")
  MENU+="${name}\x0icon\x1f${file}\n"
done < <(find "$DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \))

SELECTED=$(echo -en "$MENU" | rofi -dmenu -show-icons -theme ~/.config/rofi/config-wallpaper.rasi -p "Select Wallpaper")

[[ -z "$SELECTED" ]] && exit 0

WALL="$DIR/$SELECTED"
CURRENTWALL="$HOME/Pictures/wallpapers/current"
rm -f "$CURRENTWALL"/*

cp "$WALL" "$CURRENTWALL/"
swww img "$WALL" --transition-type any --transition-fps 60 --transition-duration 1
~/.config/hypr/scripts/update_hyprlock_wallpaper.sh
sudo cp "$HOME/Pictures/wallpapers/current/"* /usr/share/sddm/themes/simple_sddm_2/Backgrounds/default
