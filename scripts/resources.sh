#! /usr/bin/env bash

fonts=(
    "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip"
    "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Mononoki.zip"
    "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/RobotoMono.zip"
    )

function fonts() {
    mkdir -p $HOME/.local/share/fonts/{ttf,otf}
    cp -r /etc/limos/Feather $HOME/.local/share/fonts/ttf/

    for link in ${fonts[@]}; do
        name=$(basename $link)

        wget $link
        unzip $name -d "$HOME/.local/share/fonts/ttf/${name%.*}/"
        rm $name
    done

    chown $USER:$USER $HOME/.local/share/fonts/*
}

function getresources() {
    fonts

    git clone 'https://gitlab.com/limakos/limos-wallpapers.git'
    [ ! -d /usr/share/backgrounds ] && sudo mkdir /usr/share/backgrounds
    sudo mv limos-wallpapers /usr/share/backgrounds/

    git clone 'https://github.com/zsh-users/zsh-autosuggestions' ~/.zsh/zsh-autosuggestions
    git clone 'https://github.com/zsh-users/zsh-syntax-highlighting.git' ~/.zsh/zsh-syntax-highlighting
}
