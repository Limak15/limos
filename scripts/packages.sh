#! /usr/bin/env bash

packages=("git" "wget" "fakeroot" "which" "xmonad" "limos-xmonad" "xmonad-contrib" "polybar" "limos-polybar" "kitty" "limos-kitty" "rofi" "limos-rofi" "picom" "flameshot" "neovim" "limos-ttf-feather" "qt5-quickcontrols" "qt5-graphicaleffects" "vlc" "ntfs-3g" "pamixer" "pcmanfm" "slock" "xdg-user-dirs" "papirus-icon-theme" "xorg-server" "unzip" "mousepad" "lxappearance" "qt6ct" "ly" "kvantum" "lsd" "zsh" "limos-zsh" "starship" "dunst" "udiskie" "ffmpegthumbnailer" "xorg" "nm-connection-editor" "cronie" "feh" "limos-scripts" "limos-dunst" "zoxide" "limos-picom" "fzf" "base-devel" "plymouth" "limos-plymouth" "alsa-utils" "firefox" "nomacs")

fonts=(
    "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip"
    "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Mononoki.zip"
    "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/RobotoMono.zip"
    )

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
    cp -r /etc/limos/Feather $HOME/.local/share/fonts/ttf/

    for link in ${fonts[@]}; do
        name=$(basename $link)

        wget $link
        unzip $name -d "$HOME/.local/share/fonts/ttf/${name%.*}/"
        rm $name
    done

    chown $USER:$USER $HOME/.local/share/fonts/*

    git clone 'https://gitlab.com/limakos/limos-wallpapers.git'

    [ ! -d /usr/share/backgrounds ] && sudo mkdir /usr/share/backgrounds
    sudo mv limos-wallpapers /usr/share/backgrounds/

    git clone 'https://github.com/zsh-users/zsh-autosuggestions' ~/.zsh/zsh-autosuggestions
    git clone 'https://github.com/zsh-users/zsh-syntax-highlighting.git' ~/.zsh/zsh-syntax-highlighting

    sudo chsh $USER -s "/bin/zsh"
}
