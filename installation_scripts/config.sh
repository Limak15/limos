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

    wired_iface=$(ip link | awk -F: '/state UP/ && $2 ~ /en|eth/ {gsub(/ /,""); print $2}' | head -n1)
    wireless_iface=$(ip link | awk -F: '/state UP/ && $2 ~ /wl/ {gsub(/ /,""); print $2}' | head -n1)

    [ -n "$wired_iface" ] && sed -i "s/interface = .*/interface = $wired_iface/" "$CONFIG_PATH"
    [ -n "$wireless_iface" ] && sed -i "s/interface = .*/interface = $wireless_iface/" "$CONFIG_PATH"

    modules="tray pulseaudio"

    [ -n "$wireless_iface" ] && modules="$modules wireless-network"
    [ -n "$wired_iface" ] && modules="$modules wired-network"

    modules="$modules powerbtn"

    sed -i "s/^modules-right = .*/modules-right = $modules/" "$CONFIG_PATH"

    if command -v pulseaudio &> /dev/null || command -v pipewire &> /dev/null; then
        sed -i '/modules-right =  tray alsa network powerbtn/s/alsa/pulseaudio/' ~/.config/polybar/config.ini
    fi
    
    echo "feh --no-fehbg --bg-scale '/usr/share/backgrounds/limos-wallpapers/limos-dark.png'" > ~/.fehbg
    chmod 755 ~/.fehbg
    echo "~/.fehbg &" > ~/.xsession
}
