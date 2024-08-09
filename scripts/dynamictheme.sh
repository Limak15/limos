#!/usr/bin/env bash

function enable_dynamic_theme() {
    echo "~/.local/bin/limos-theme" >> $HOME/.xsession
    sudo systemctl enable --now cronie.service
    crontab crontab.txt
}

function apply_default_theme() {
    path=/usr/share/backgrounds/limos-wallpapers
    polybar_path=~/.config/polybar/config.ini
    xmonad_path=~/.config/xmonad/xmonad.hs
    rofi_powermenu_path=~/.config/rofi/powermenu/powermenu.rasi
    rofi_message_path=~/.config/rofi/powermenu/message.rasi
    rofi_confirm_path=~/.config/rofi/powermenu/confirm.rasi
    rofi_finder_path=~/.config/rofi/config.rasi
    dunst_path=~/.config/dunst/dunstrc

    if [ -f "$polybar_path" ]; then
        sed -i "s/include-file = colors\/[^ ]*/include-file = colors\/colors6.ini/g" "$polybar_path"
    fi

    kitten themes --reload-in=all "color6"

    if [ -f "$xmonad_path" ]; then
        sed -i 's/import Colors\.[^ ]*/import Colors.Colors6/g' "$xmonad_path"
    fi

    if [ -f "$rofi_powermenu_path" ] && [ -f "$rofi_confirm_path" ] && [ -f "$rofi_message_path" ] && [ -f "$rofi_finder_path" ]; then
        sed -i 's/@import "..\/[^"]*"/@import "..\/colors\/colors6.rasi"/g' "$rofi_powermenu_path"
        sed -i 's/@import "..\/[^"]*"/@import "..\/colors\/colors6.rasi"/g' "$rofi_message_path"
        sed -i 's/@import "..\/[^"]*"/@import "..\/colors\/colors6.rasi"/g' "$rofi_confirm_path"
        sed -i 's/@import "[^"]*"/@import "colors\/colors6.rasi"/g' "$rofi_finder_path"
    fi

    if [ -f "$dunst_path" ]; then
        dunst_colors=$HOME/.config/dunst/colors
        bg=$(awk -F= '/background/ {print $2}' "$dunst_colors/colors6.txt")
        fg=$(awk -F= '/foreground/ {print $2}' "$dunst_colors/colors6.txt")
        fr=$(awk -F= '/frame/ {print $2}' "$dunst_colors/colors6.txt")

        sed -i -e 's/background = "#[^"]*"/background = "'"$bg"'"/g' -e 's/foreground = "#[^"]*"/foreground = "'"$fg"'"/g' -e 's/frame_color = "#[^"]*"/frame_color = "'"$fr"'"/g' "$dunst_path" 
    fi
}
