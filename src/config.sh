#! /usr/bin/env bash

function configure_desktop() {
    [ -f $HOME/.bashrc ] && mv $HOME/.bashrc $HOME/.bashrc.old
    [ ! -d $HOME/.config ] && mkdir $HOME/.config
    [ ! -d $HOME/.local/bin ] && mkdir -p $HOME/.local/bin

    for dir in config/{polybar,xmonad,rofi,kitty,dunst,picom,fastfetch}; do
        ln -s "$(pwd)/$dir" "$HOME/.config/"
    done

    ln -s "$(pwd)/config/bash/bashrc" $HOME/.bashrc
    ln -s "$(pwd)/config/starship/starship.toml" $HOME/.config/starship.toml
    sudo cp -r ./config/plymouth /usr/share/plymouth/themes/limos

    for script in config/*; do
        ln -s "$(pwd)/$script" $HOME/.local/bin/
    done

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
