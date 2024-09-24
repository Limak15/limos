#! /usr/bin/env bash

packages=("git" "wget" "fakeroot" "which" "xmonad" "xmonad-contrib" "polybar" "kitty" "rofi" "picom" "flameshot" "neovim" "qt5-quickcontrols" "qt5-graphicaleffects" "vlc" "ntfs-3g" "pcmanfm" "slock" "xdg-user-dirs" "papirus-icon-theme" "xorg-server" "unzip" "mousepad" "lxappearance" "qt6ct" "ly" "kvantum" "lsd" "starship" "dunst" "udiskie" "ffmpegthumbnailer" "xorg" "nm-connection-editor" "feh" "zoxide" "fzf" "base-devel" "plymouth" "alsa-utils" "firefox" "nomacs" "fastfetch")

FONT_LINK="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip"
FONT_NAME="MesloLGLDZ Nerd Font"

function install_packages() {
    sudo pacman -Sy --noconfirm --needed "${packages[@]}"

    if ! command -v pulseaudio &> /dev/null && ! command -v pipewire &> /dev/null; then
        server_choice=$(whiptail --title "$TITLE" --radiolist "Choose audioserver (No choice: alsa will be used)" 20 60 3 "pulseaudio" "General purpose sound server." OFF "pipewire" "A new low-level multimedia framework" OFF 3>&1 1>&2 2>&3)

        case $server_choice in
            "pulseaudio")
                sudo pacman -Sy --needed --noconfirm "$server_choice" pavucontrol pamixer
                ;;
            "pipewire")
                sudo pacman -Sy --needed --noconfirm "$server_choice" pipewire-pulse pavucontrol pamixer
                ;;
        esac
    fi
    
    mkdir -p $HOME/.local/share/fonts/{ttf,otf}
    cp -r ./fonts/Feather $HOME/.local/share/fonts/ttf/

    if fc-list | grep -q "$FONT_NAME"; then
        echo "$FONT_NAME is already installed"
    else
        tmp=$(mktemp -d)
        wget "$FONT_LINK" -O "$tmp/Meslo.zip"
        unzip "$tmp/Meslo.zip" -d "$HOME/.local/share/fonts/ttf/Meslo/"
    fi

    git clone 'https://gitlab.com/limakos/limos-wallpapers.git'

    [ ! -d /usr/share/backgrounds ] && sudo mkdir /usr/share/backgrounds
    sudo mv limos-wallpapers /usr/share/backgrounds/
}
