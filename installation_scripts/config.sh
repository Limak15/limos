#! /usr/bin/env bash

function configure_desktop() {
    [ -f $HOME/.bashrc ] && mv $HOME/.bashrc $HOME/.bashrc.old
    [ ! -d $HOME/.config ] && mkdir $HOME/.config
    [ ! -d $HOME/.local/bin ] && mkdir -p $HOME/.local/bin

    for dir in ./config/{polybar,xmonad,rofi,kitty,dunst,picom}; do
        cp -r "$dir" "$HOME/.config/"
    done

    cp ./config/bash/bashrc $HOME/.bashrc
    cp -r ./config/bash/fastfetch $HOME/.config/
    cp ./config/starship/starship.toml $HOME/.config/starship.toml
    cp ./DEscripts/* $HOME/.local/bin
    sudo cp -r ./config/plymouth /usr/share/plymouth/themes/limos

    [ ! -d $HOME/.icons ] && mkdir $HOME/.icons
    [ ! -d $HOME/.themes ] && mkdir $HOME/.themes

    cp -r ./themes/gtk/Fluent-green-Dark $HOME/.themes/
    cp -r ./themes/icons/* $HOME/.icons/
    
    echo "feh --no-fehbg --bg-scale '/usr/share/backgrounds/limos-wallpapers/limos-dark.png'" > ~/.fehbg
    chmod 755 ~/.fehbg
    echo "~/.fehbg &" > ~/.xsession
}
