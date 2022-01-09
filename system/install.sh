#!/bin/sh

# Move fstab into place
sudo ln -s fstab /etc/fstab

# Move systemd overrides into place
sudo mkdir /etc/systemd/system/getty@tty1.service.d && sudo ln -s systemd/getty@tty1.service.d/* /etc/systemd/system/getty@tty1.service.d/*

# Move grub config into place
sudo ln -s grub/default/grub /etc/default/grub
sudo ln -s grub/grub.cfg /boot/grub/grub.cfg

# Move lightdm config and themes into place
sudo ln -s lightdm/lightdm.conf /etc/lightdm/lightdm.conf
sudo ln -s lightdm/lightdm-webkit2-greeter.conf /etc/lightdm/lightdm-webkit2-greeter.conf