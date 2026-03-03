#!/bin/bash
# Скрипт для обновления кэша обоев SDDM
USER_HOME="/home/nurkobunny"
WALLPAPER_DIR="$USER_HOME/Pictures/wallpapers/current"
CACHE_DIR="$USER_HOME/.cache/sddm-wallpaper"
CURRENT_WALLPAPER="$CACHE_DIR/current-wallpaper"

# Создаем директорию для кэша если не существует
mkdir -p "$CACHE_DIR"
chmod 700 "$CACHE_DIR"

# Находим все файлы обоев
WALLPAPERS=($(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) 2>/dev/null))

# Если нашли обои - выбираем случайный
if [ ${#WALLPAPERS[@]} -gt 0 ]; then
    RANDOM_WALLPAPER=${WALLPAPERS[$RANDOM % ${#WALLPAPERS[@]}]}
    
    # Копируем выбранный wallpaper в кэш
    cp "$RANDOM_WALLPAPER" "$CURRENT_WALLPAPER"
    chmod 600 "$CURRENT_WALLPAPER"
    echo "SDDM wallpaper updated: $RANDOM_WALLPAPER"
else
    # Fallback если файлы не найдены
    echo "No wallpapers found in $WALLPAPER_DIR"
fi
