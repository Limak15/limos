#! /usr/bin/env bash

function config_files() {
    [ -f $HOME/.zshrc ] && mv $HOME/.zshrc $HOME/.zshrc.backup
    [ ! -d $HOME/.config ] && mkdir $HOME/.config
    [ -d $HOME/.config ] && mkdir $HOME/.config.backup && cp -rf $HOME/.config $HOME/.config.backup
    [ ! -d $HOME/.local/bin ] && mkdir $HOME/.local/bin

    for dir in /etc/limos/{polybar,xmonad,rofi,kitty,dunst,picom}; do
        cp -r "$dir" "$HOME/.config/"
    done

    cp /etc/limos/zsh/zshrc $HOME/.zshrc
    cp /etc/limos/scripts/* $HOME/.local/bin
    sudo cp -r /etc/limos/plymouth /usr/share/plymouth/themes/limos 

    network_interface=$(ip -o link show | awk '$9 == "UP" {print $2}' | sed 's/://')
    [ -f "$HOME/.config/polybar/config.ini" ] && sed -i 's/interface = .*/interface = '"$network_interface"'/' $HOME/.config/polybar/config.ini

    if command -v pulseaudio &> /dev/null || command -v pipewire &> /dev/null; then
        sed -i '/modules-right =  tray alsa network powerbtn/s/alsa/pulseaudio/' ~/.config/polybar/config.ini
    fi

    feh --bg-scale /usr/share/backgrounds/7.jpg
    echo "~/.fehbg &" > ~/.xsession
}
