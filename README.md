# 💫 Hyprland Custom Rice - Dracula & Multi-Theme 
#### Based on JaKooLit's dots!

A highly customized Hyprland environment featuring deep integration with Dracula and various other themes (Catppuccin, Rose Pine, etc.).

---

## 👀 Themes Preview

<details>
<summary><b>Click to expand Theme Gallery</b></summary>

### 🎨 Theme: Catppuccin Macchiato
```text
|
|─── 📂 System Interface
|   ├── 🖼️ [GRUB Menu](./assets/Catppuccin/grub.png)
|   └── 🖼️ [SDDM Login](./assets/Catppuccin/sddm.png)
|
|─── 📂 Desktop Environment
|   ├── 🖼️ [Waybar Layout](./assets/Catppuccin/waybar.png)
|   ├── 🖼️ [Rofi Launcher](./assets/Catppuccin/rofi.png)
|   └── 🖼️ [SwayNC Notifications](./assets/Catppuccin/swaync.png)
|
|─── 📂 Applications
|   ├── 🖼️ [Kitty Terminal](./assets/Catppuccin/kitty.png)
|   ├── 🖼️ [Neovim Editor](./assets/Catppuccin/nvim.png)
|   ├── 🖼️ [Spotify (Spicetify)](./assets/Catppuccin/spotify.png)
|   ├── 🖼️ [VS Code](./assets/Catppuccin/vscode.png)
|   ├── 🖼️ [Obsidian Vault](./assets/Catppuccin/obsidian.png)
|   └── 🖼️ [Thunar & GTK Apps](./assets/Catppuccin/thunar.png)
```

---

### 🎨 Theme: Dracula (Main)
*Add your paths here in the same tree format...*

</details>

---

## 🚀 Manual Installation Guide

### 1. Install AUR Helper (yay)
Ensure your system is up to date and install `yay` to handle AUR dependencies.

```bash
sudo pacman -Syu --needed base-devel git
git clone [https://aur.archlinux.org/yay-bin.git](https://aur.archlinux.org/yay-bin.git)
cd yay-bin
makepkg -si
```

### 2. Install Core Dependencies
This list is compiled from JaKooLit's base requirements and your custom components.

```bash
# Core Hyprland & Wayland Tools
yay -S --needed hyprland waybar swaync rofi-wayland swww hyprlock hypridle \
wlogout nwg-look wallust kitty pywal-16-colors pavucontrol grimblast-git slurp swappy

# Fonts & Icons (Essential for UI)
yay -S --needed ttf-firacode-nerd ttf-font-awesome noto-fonts-emoji \
papirus-icon-theme

# Utilities & CLI 
yay -S --needed fastfetch cava zsh neovim tty-clock pipes.sh \
thunar xarchiver btop
```

### 3. Deploy Configuration Files
Copy the configurations from this repository to your system.

```bash
# Copy .config directories
cp -r config/* ~/.config/

# Copy Wallpapers & Assets
mkdir -p ~/Pictures/wallpapers
cp -r Pictures/* ~/Pictures/
```

---

## 🔧 Component Setup

### 🎵 Spotify (Spicetify)
Make sure Spotify is installed (Flatpak or Pacman) before applying.
```bash
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R

spicetify backup apply
```

### 🖥️ SDDM & GRUB
```bash
# SDDM Theme
sudo cp -r sddm/simple_sddm_2 /usr/share/sddm/themes/
sudo cp sddm/sddm.conf /etc/sddm.conf

# GRUB Theme
sudo cp -r grub/* /usr/share/grub/themes/

sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### 📝 Edit Sudoers (Required for theme scripts)
To allow theme-switching scripts to modify system files without a password prompt:
```text
# Run 'sudo visudo' and add these lines at the end:
YourUser ALL=(ALL) NOPASSWD: /usr/bin/sed *, /etc/default/grub
YourUser ALL=(ALL) NOPASSWD: /usr/bin/sed *, /usr/share/sddm/themes/simple_sddm_2/metadata.desktop
YourUser ALL=(ALL) NOPASSWD: /usr/bin/grub-mkconfig *
YourUser ALL=(ALL) NOPASSWD: /bin/cp
```

---

## ⌨️ Keybindings
* `Super + Q` - Close Active Window
* `Super + Return` - Kitty Terminal
* `Super + E` - File Manager (Thunar)
* `Super + W` - Choose Wallpapers
* `Super + T` - Theme-switcher
* `Super + D` - App Menu (Rofi)
* `Super + L` - Lock Screen
* `Super + SHIFT + N` - SwayNC Notification Center
* `Ctrl + Alt + P` - Power Menu (Wlogout)

