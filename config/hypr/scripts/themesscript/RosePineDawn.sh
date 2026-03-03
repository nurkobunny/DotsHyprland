#!/bin/zsh

CONFIG_FILE="$HOME/.config/hypr/pathtonotes.conf"

if [ -f "$CONFIG_FILE" ]; then
    OBSIDIAN_VAULT=$(cat "$CONFIG_FILE")
else
    echo "Enter full path to your Obsidian vault (example: ~/.config/obsidian/notes/ MANDATORY / at the end):"
    read -r OBSIDIAN_VAULT
    echo "$OBSIDIAN_VAULT" > "$CONFIG_FILE"
fi

COLOR_HEX="#9580AC"
COLOR_ANSI="5"
cp $HOME/.config/gtk-3.0/Themes/RosePineDawn.css $HOME/.config/gtk-3.0/gtk.css* 
gsettings set org.gnome.desktop.interface cursor-theme 'BreezeX-RosePine-Linux'
gsettings set org.gnome.desktop.interface cursor-size 24
hyprctl setcursor BreezeX-RosePine-Linux 24
sed -i "s/^exec-once=hyprctl setcursor .*/exec-once=hyprctl setcursor BreezeX-RosePine-Linux 24/" "$HOME/.config/hypr/UserConfigs/Startup_Apps.conf"
mv $HOME/.config/gtk-3.0/gtk.css* $HOME/.config/gtk-3.0/gtk.css
gsettings set org.gnome.desktop.interface gtk-theme "Rosepine-BL-LB-Light"
gsettings set org.gnome.desktop.interface icon-theme "rose-pine-dawn-icons"

USER_DECOR="$HOME/.config/hypr/UserConfigs/UserDecorations.conf"
sed -i 's/^.*col\.active_border.*/col.active_border = rgb(907aa9)/' "$USER_DECOR"
sed -i 's/^.*col\.inactive_border.*/col.inactive_border = rgb(f2e9e1)/' "$USER_DECOR"

WALL_DIR="$HOME/Pictures/wallpapers/Dynamic-Wallpapers/RosePineDawn/"
CURRENTWALL="$HOME/Pictures/wallpapers/current"
WALL=$(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf -n 1)
mkdir -p "$CURRENTWALL"
rm -f "$CURRENTWALL"/*
cp "$WALL" "$CURRENTWALL/"
if command -v swww &> /dev/null; then
    pgrep -x swww-daemon > /dev/null || swww-daemon &
    sleep 0.5
    swww img "$WALL" --transition-type any --transition-fps 60 --transition-duration 1
fi

HYPRLOCK_CONFIG="$HOME/.config/hypr/hyprlockthemes/RosePineDawn.conf"
[ -f "$HYPRLOCK_CONFIG" ] && cp "$HYPRLOCK_CONFIG" "$HOME/.config/hypr/hyprlock.conf"

sudo sed -i 's/ConfigFile=Themes\/.*/ConfigFile=Themes\/RosePineDawn.conf/' /usr/share/sddm/themes/simple_sddm_2/metadata.desktop
sudo cp "$HOME"/Pictures/wallpapers/current/* /usr/share/sddm/themes/simple_sddm_2/Backgrounds/default

WALLALLDIREC="$HOME/Pictures/fastfetch/rosepinedawn"
WALLFASTDIREC="$HOME/Pictures/fastfetch/curent"
mkdir -p "$WALLFASTDIREC"
WALLFAST=$(find "$WALLALLDIREC" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf -n 1)
rm -f "$WALLFASTDIREC"/*
cp "$WALLFAST" "$WALLFASTDIREC/"

kitten themes --reload-in=all Rosé Pine Dawn

CAVA_CONFIG="$HOME/.config/cava/config"
sed -i "s|^BACKGROUND *=.*|BACKGROUND = default|" "$CAVA_CONFIG"
sed -i "s|^FOREGROUND *=.*|FOREGROUND = '$COLOR_HEX'|" "$CAVA_CONFIG"
sed -i "s|^GRADIENT *=.*|GRADIENT = 0|" "$CAVA_CONFIG"

PIPES="pipes.sh -c $COLOR_ANSI -f 60"
sed -i "s|^alias pipes\.sh=.*|alias pipes.sh='$PIPES'|" "$HOME/.zshrc"
CLOCK="tty-clock -c -C $COLOR_ANSI -D"
sed -i "s|^alias tty-clock=.*|alias tty-clock='$CLOCK'|" "$HOME/.zshrc"

NVIM_CONFIG="$HOME/.config/nvim/init.vim"
if [ -f "$NVIM_CONFIG" ]; then
    sed -i "s/theme = '.*'/theme = 'rose-pine'/" "$NVIM_CONFIG"
    sed -i "s/variant = '.*'/variant = 'dawn'/" "$NVIM_CONFIG"
    sed -i "s/^colorscheme .*$/colorscheme rose-pine-dawn/" "$NVIM_CONFIG"
    pkill -x nvim
fi

OBSIDIAN_CONFIG="$OBSIDIAN_VAULT.obsidian/appearance.json"
if [ -f "$OBSIDIAN_CONFIG" ]; then
    sed -i 's/"cssTheme": *".*"/"cssTheme": "Rose Pine"/' "$OBSIDIAN_CONFIG"
    sed -i 's/"theme": *".*"/"theme": "moonstone"/' "$OBSIDIAN_CONFIG"
    pkill -f "obsidian"
    obsidian "$OBSIDIAN_VAULT" & disown
fi

VSCODE_SETTINGS="$HOME/.config/Code - OSS/User/settings.json"
if [ -f "$VSCODE_SETTINGS" ]; then
    sed -i 's/"workbench.colorTheme": *".*"/"workbench.colorTheme": "Rosé Pine Dawn"/' "$VSCODE_SETTINGS"
fi

ROFI_CONFIG="$HOME/.config/rofi/style.rasi"
sed -i 's|^@theme.*|@theme "~/.config/rofi/wallust/RosePineDawn.rasi"|' "$ROFI_CONFIG"

PROFILE_DIR=$(find "$HOME/.mozilla/firefox" -maxdepth 1 -type d -name "*.default-release" | head -n 1)
if [ -d "$PROFILE_DIR" ]; then
    cp -f "$HOME/.config/firefox-themes/RosePineDawn/userChrome.css" "$PROFILE_DIR/chrome/"
    cp -f "$HOME/.config/firefox-themes/RosePineDawn/index.html" "$HOME/.config/firefox-custom-addons/index.html"
    pkill -x firefox && nohup firefox &> /dev/null &
fi

pkill swaync
cp "$HOME/.config/swaync/Themes/RosePineDawn.css" "$HOME/.config/swaync/style.css"
swaync & disown

spicetify config color_scheme rosepine-dawn
spicetify apply -n
if pgrep -x "spotify" > /dev/null; then
    flatpak kill com.spotify.Client
    flatpak run com.spotify.Client & disown
fi

cp "$HOME/.config/waybar/style/RosePineDawn.css" "$HOME/.config/waybar/style.css"
killall waybar && waybar & disown

THEMEFOLDER="/usr/share/grub/themes/"
THEME="RosePineDawn"
GRUBCONF="/etc/default/grub"
if grep -q "^GRUB_THEME=" "$GRUBCONF"; then
   sudo sed -i "s|^GRUB_THEME=.*|GRUB_THEME=\"${THEMEFOLDER}${THEME}/theme.txt\"|" "$GRUBCONF"
else
    echo "GRUB_THEME=\"${THEMEFOLDER}${THEME}/theme.txt\"" | sudo tee -a "$GRUBCONF" > /dev/null
fi
sudo grub-mkconfig -o /boot/grub/grub.cfg
