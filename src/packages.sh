#! /usr/bin/env bash

packages=("git" "wget" "fakeroot" "xfce4-power-manager" "network-manager-applet" "which" "pulseaudio" "pavucontrol" "pamixer" "xmonad" "xmonad-contrib" "polybar" "kitty" "rofi" "flameshot" "neovim" "qt5-quickcontrols" "qt5-graphicaleffects" "vlc" "ntfs-3g" "thunar" "slock" "xdg-user-dirs" "xorg-server" "unzip" "mousepad" "lxappearance-gtk3" "qt6ct" "ly" "kvantum" "lsd" "starship" "dunst" "udiskie" "ffmpegthumbnailer" "xorg" "nm-connection-editor" "feh" "zoxide" "fzf" "base-devel" "plymouth" "alsa-utils" "firefox" "nomacs" "fastfetch")

FONT_LINK="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip"
FONT_NAME="MesloLGLDZ Nerd Font"

function install_packages() {
    sudo pacman -Sy --noconfirm --needed "${packages[@]}"
    
    mkdir -p $HOME/.local/share/fonts/{ttf,otf}
    cp -r ./fonts/Feather $HOME/.local/share/fonts/ttf/

    if fc-list | grep -q "$FONT_NAME"; then
        echo "$FONT_NAME is already installed"
    else
        tmp=$(mktemp -d)
        wget "$FONT_LINK" -O "$tmp/Meslo.zip"
        unzip "$tmp/Meslo.zip" -d "$HOME/.local/share/fonts/ttf/Meslo/"
    fi

    [ ! -d /usr/share/backgrounds ] && sudo mkdir /usr/share/backgrounds

    if [ ! -d /usr/share/background/limos-wallpapers ]; then
        git clone 'https://gitlab.com/limakos/limos-wallpapers.git'

        sudo mv limos-wallpapers /usr/share/backgrounds/
    else
        echo "limos-wallpapers directory already exists"
    fi
}
