#! /usr/bin/env bash

function copy_config_files() {
    [ -f $HOME/.bashrc ] && mv $HOME/.bashrc $HOME/.bashrc.old
    [ ! -d $HOME/.config ] && mkdir $HOME/.config
    [ ! -d $HOME/.local/bin ] && mkdir -p $HOME/.local/bin

    for dir in ../config/{polybar,xmonad,rofi,kitty,dunst,picom}; do
        cp -r "$dir" "$HOME/.config/"
    done

    cp ../config/bash/bashrc $HOME/.bashrc
    cp ../DEscripts/* $HOME/.local/bin
    sudo cp -r ../config/plymouth /usr/share/plymouth/themes/limos 

    network_interface=$(ip -o link show | awk '$9 == "UP" {print $2}' | sed 's/://')
    [ -f "$HOME/.config/polybar/config.ini" ] && sed -i 's/interface = .*/interface = '"$network_interface"'/' $HOME/.config/polybar/config.ini

    if command -v pulseaudio &> /dev/null || command -v pipewire &> /dev/null; then
        sed -i '/modules-right =  tray alsa network powerbtn/s/alsa/pulseaudio/' ~/.config/polybar/config.ini
    fi
    
    echo "feh --no-fehbg --bg-scale '/usr/share/backgrounds/limos-wallpapers/limos-dark.png'" > ~/.fehbg
    chmod 755 ~/.fehbg
    echo "~/.fehbg &" > ~/.xsession
}
