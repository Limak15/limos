#! /usr/bin/env bash

function addrepos() {
    limos_repo_section="[limos-main-repo]\nSigLevel = Optional DatabaseOptional\nServer = https://gitlab.com/limakos/limos-main-repo/-/raw/master/"'$arch'
    chaotic_aur="[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist"

    sudo cp /etc/pacman.conf /etc/pacman.conf.bak 

    echo -e $limos_repo_section | sudo tee -a /etc/pacman.conf

    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB
    yes | sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
    yes | sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

    echo -e $chaotic_aur | sudo tee -a /etc/pacman.conf
}
