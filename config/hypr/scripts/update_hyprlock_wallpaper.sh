#!/bin/bash
WALLPAPER_DIR="$HOME/Pictures/wallpapers/current"
HYPRLOCK_WALLPAPER="$HOME/.cache/hyprlock_current_wallpaper"

# Создаем директорию для кэша если не существует
mkdir -p "$(dirname "$HYPRLOCK_WALLPAPER")"

# Находим случайный wallpaper
RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | shuf -n 1)

# Копируем выбранный wallpaper в фиксированное место
if [ -n "$RANDOM_WALLPAPER" ] && [ -f "$RANDOM_WALLPAPER" ]; then
    cp "$RANDOM_WALLPAPER" "$HYPRLOCK_WALLPAPER"
    echo "Updated hyprlock wallpaper: $RANDOM_WALLPAPER"
else
    # Fallback если файлы не найдены
    echo "No wallpapers found, using fallback"
    # Можно установить fallback wallpaper
    cp /usr/share/backgrounds/archlinux/arch-wallpaper.jpg "$HYPRLOCK_WALLPAPER" 2>/dev/null || true
fi
