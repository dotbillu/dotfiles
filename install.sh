#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_SUFFIX=".backup-$(date +%Y%m%d-%H%M%S)"

if ! command -v paru &> /dev/null; then
    echo "Installing paru..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    (cd /tmp/paru && makepkg -si --noconfirm)
    rm -rf /tmp/paru
fi


paru -Syu --needed --noconfirm \
kitty \
dolphin \
fuzzel \
neovim \
hyprshot \
ags-hyprpanel-git \
hyprlock \
sddm \
wpctl \
brightnessctl \
playerctl \
qt6ct \
gnome-keyring \
gsettings


if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
    echo "Default shell changed to zsh."
fi

install_item() {
    local src="$1"
    local dest="$2"

    if [ ! -e "$src" ]; then
        return
    fi

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        current_link=$(readlink -f "$dest")
        if [ "$current_link" == "$src" ]; then
            return
        fi
        mv "$dest" "${dest}${BACKUP_SUFFIX}"
        echo "Backed up $dest to ${dest}${BACKUP_SUFFIX}"
    fi

    ln -s "$src" "$dest"
    echo "Linked $src -> $dest"
}

ZSH_FILES=(".zshrc" ".zshrc.alias" ".zshrc.themes")

for file in "${ZSH_FILES[@]}"; do
    install_item "$SCRIPT_DIR/$file" "$HOME/$file"
done

mkdir -p "$HOME/.config"
CONFIG_DIRS=("hypr" "nvim" "fuzzel" "kitty" "sheldon")

for dir in "${CONFIG_DIRS[@]}"; do
    install_item "$SCRIPT_DIR/$dir" "$HOME/.config/$dir"
done

if [ -d "$SCRIPT_DIR/sddm/aerial-sddm-theme" ]; then
    sudo cp -rf "$SCRIPT_DIR/aerial-sddm-theme" /usr/share/sddm/themes/
fi

SDDM_CONF="/etc/sddm.conf"
if [ ! -f "$SDDM_CONF" ]; then
    sudo touch "$SDDM_CONF"
fi

if ! grep -q "^\[Theme\]" "$SDDM_CONF"; then
    echo -e "[Theme]\nCurrent=aerial-sddm-theme" | sudo tee -a "$SDDM_CONF" > /dev/null
else
    sudo sed -i '/^\[Theme\]/,/^\[/ s/^Current=.*/Current=aerial-sddm-theme/' "$SDDM_CONF"
fi

echo "Installation complete."

