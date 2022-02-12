#!/bin/sh

echo "==> Installing paru..."
sudo pacman -S --needed base-devel --noconfirm
mkdir ~/pkgs && cd ~/pkgs
git clone https://aur.archlinux.org/paru.git paru/
cd paru/ && makepkg -si
