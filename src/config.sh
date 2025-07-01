#! /usr/bin/env bash

function configure_desktop() {
    [ -f $HOME/.bashrc ] && mv $HOME/.bashrc $HOME/.bashrc.old
    [ ! -d $HOME/.config ] && mkdir $HOME/.config
    [ ! -d $HOME/.local/bin ] && mkdir -p $HOME/.local/bin

    for dir in config/{polybar,xmonad,rofi,kitty,dunst,picom,fastfetch}; do
        cp -r "$dir" "$HOME/.config/"
    done
    
    cp ./config/bash/bashrc $HOME/.bashrc
    cp -r ./config/fastfetch $HOME/.config/
    cp ./config/starship/starship.toml $HOME/.config/starship.toml
    cp ./scripts/* $HOME/.local/bin
    sudo cp -r ./config/plymouth /usr/share/plymouth/themes/limos

    [ ! -d $HOME/.icons ] && mkdir $HOME/.icons
    [ ! -d $HOME/.themes ] && mkdir $HOME/.themes

    cp -r ./themes/gtk/Fluent-green-Dark $HOME/.themes/
    cp -r ./themes/icons/* $HOME/.icons/
    
    echo "feh --no-fehbg --bg-scale '/usr/share/backgrounds/limos-wallpapers/limos-dark.png'" > ~/.fehbg
    chmod 755 ~/.fehbg
    echo "~/.fehbg &" > ~/.xsession

    [ ! -d $GTK_CONFIG_PATH ] && mkdir $GTK_CONFIG_PATH
    [ ! -f "$GTK_CONFIG_PATH/settings.ini" ] && touch "$GTK_CONFIG_PATH/settings.ini"

    gtk_config="[Settings]
    gtk-theme-name=$GTK_THEME
    gtk-icon-theme-name=$ICON_THEME"

    echo "$gtk_config" >> "$GTK_CONFIG_PATH/settings.ini"
}
