#!/bin/sh

# .config
ln -s .config/*/ ~/*/

# Xorg stuff
ln -s .xinitrc ~/.xinitrc
ln -s .Xresources ~/.Xresources
ln -s .Xauthority ~/.Xauthority

# Vim
ln -s vim/.vim/* ~/.vim/*
ln -s vim/* ~/*
