#! /usr/bin/env bash

function audioserver() {
    if ! command -v pulseaudio &> /dev/null && ! command -v pipewire &> /dev/null; then
        server_choice=$(whiptail --title "$TITLE" --radiolist "Choose audioserver (No choice: alsa will be used)" 20 60 3 "pulseaudio" "General purpose sound server." OFF "pipewire" "A new low-level multimedia framework" OFF 3>&1 1>&2 2>&3)

        case $server_choice in
            "pulseaudio")
                sudo pacman -S --needed --noconfirm "$server_choice" pavucontrol pamixer
                ;;
            "pipewire")
                sudo pacman -S --needed --noconfirm "$server_choice" pipewire-pulse pavucontrol pamixer
                ;;
        esac
    fi
}
