### About LimOS
---
**LimOS** is a post installation script that will install and configure window manager along with all applications and utilities that are needed to create fully functional desktop environment. This script should work on every Arch based distribution.

![desktop!](https://gitlab.com/Limak01/dotfiles/-/raw/master/.screenshots/theme6.png)

**Note:** _This is one of 12 themes available for **LimOS**. To see how other themes look like go to https://gitlab.com/Limak01/dotfiles/-/tree/master/.screenshots_


### installation
---
```
git clone https://gitlab.com/limakos/Limos
cd limos
./limOS

```

### About dynamic theme
---
It's a script that will change desktop theme and wallpaper every two hours. When you run **limOS** script you will be asked if you want to enable dynamic theme. If you choose to disable it theme number 6 will be used as default but you can easly change for your prefered theme using:
`limos-theme <number_of_theme>`

### Basic keybinds
---
**Note:** _mod is by default bound to windows key_
|Keys|Description|
|---|---|
|<kbd>mod</kbd> + <kbd>shift</kbd> + <kbd>enter</kbd>|Open terminal (kitty)|
|<kbd>mod</kbd> + <kbd>p</kbd>|Open application finder (rofi)|
|<kbd>mod</kbd> + <kbd>z</kbd>|Open powermenu (rofi)|
|<kbd>mod</kbd> + <kbd>shift</kbd> + <kbd>c</kbd>|Close active window|
|<kbd>mod</kbd> + <kbd>1 to 9</kbd>|Switch workspace|
|<kbd>mod</kbd> + <kbd>shift</kbd> + <kbd>1 to 9</kbd>|Move active window to another workspace|

#### Volume nad audio control
**Note:** _If you don't have xF86XK keys on your keyboard u can change bindings in xmonad config file in ~/.config/xmonad/xmonad.hs_

**Note:** _By default only 3 music players are available to control strawberry, spotify, DeaDBeeF.If you want to add more players edit ~/.local/bin/limos-mediactrl and add your player name here `players=("strawberry" "spotify" "DeaDBeeF")`. The player name must be identical to the one used in dbus_
|Keys|Description|
|---|---|
|<kbd>xF86XK_AudioRaiseVolume</kbd>|Raise volume|
|<kbd>xF86XK_AudioLowerVolume</kbd>|Lower volume|
|<kbd>xF86XK_AudioMute</kbd>|Audio mute|
|<kbd>xF86XK_AudioNext</kbd>|Play next song|
|<kbd>xF86XK_AudioPrev</kbd>|Play previous song|
|<kbd>xF86XK_AudioPlay</kbd>|Toggle play or pause|

