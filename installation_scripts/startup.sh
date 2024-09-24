#! /usr/bin/env bash

function startupstuff() {
    dm=$(systemctl show display-manager.service --property=Id --value)

    sudo systemctl disable $dm

    sudo systemctl enable ly.service

    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/' /etc/default/grub

    sudo grub-mkconfig -o /boot/grub/grub.cfg

    sudo sed -i 's/\(HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck\))/\1 plymouth)/' /etc/mkinitcpio.conf

    sudo plymouth-set-default-theme -R limos
}
