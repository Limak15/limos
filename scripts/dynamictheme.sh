#!/usr/bin/env bash

crontab_src="0 * * * env DISPLAY=:0 $HOME/.local/bin/limos-theme 0\n\
0 2 * * * env DISPLAY=:0 $HOME/.local/bin/limos-theme 1\n\ 
0 4 * * * env DISPLAY=:0 $HOME/.local/bin/limos-theme 2\n\ 
0 6 * * * env DISPLAY=:0 $HOME/.local/bin/limos-theme 3\n\ 
0 8 * * * env DISPLAY=:0 $HOME/.local/bin/limos-theme 4\n\ 
0 10 * * * env DISPLAY=:0 $HOME/.local/bin/limos-theme 5\n\ 
0 12 * * * env DISPLAY=:0 $HOME/.local/bin/limos-theme 6\n\ 
0 14 * * * env DISPLAY=:0 $HOME/.local/bin/limos-theme 7\n\ 
0 16 * * * env DISPLAY=:0 $HOME/.local/bin/limos-theme 8\n\ 
0 18 * * * env DISPLAY=:0 $HOME/.local/bin/limos-theme 9\n\ 
0 20 * * * env DISPLAY=:0 $HOME/.local/bin/limos-theme 10\n\ 
0 22 * * * env DISPLAY=:0 $HOME/.local/bin/limos-theme 11\n"

function enable_dynamic_theme() {
    echo "~/.local/bin/limos-theme" >> $HOME/.xsession
    sudo systemctl enable --now cronie.service
    crontab $crontab_src 
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
