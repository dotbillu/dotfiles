#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_SUFFIX=".backup-$(date +%Y%m%d-%H%M%S)"

# --- Install Paru ---
if ! command -v paru &> /dev/null; then
    echo "Installing paru..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    (cd /tmp/paru && makepkg -si --noconfirm)
    rm -rf /tmp/paru
fi

# --- Install Packages ---
paru -S --needed --noconfirm fuzzel zsh kitty neovim hyprshot ags-hyprpanel-git



if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
    echo "Default shell changed to zsh."
fi

# --- Link Function ---
install_item() {
    local src="$1"
    local dest="$2"

    if [ ! -e "$src" ]; then
        return
    fi

    # Backup existing if it's not already the correct link
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

# --- Install Files ---
# ZSH files to ~
ZSH_FILES=(".zshrc" ".zshrc.alias" ".zshrc.theme")

for file in "${ZSH_FILES[@]}"; do
    install_item "$SCRIPT_DIR/$file" "$HOME/$file"
done

# Config folders to ~/.config/
mkdir -p "$HOME/.config"
CONFIG_DIRS=("hypr" "nvim" "fuzzel" "kitty" "sheldon")

for dir in "${CONFIG_DIRS[@]}"; do
    install_item "$SCRIPT_DIR/$dir" "$HOME/.config/$dir"
done

echo "Installation complete."
