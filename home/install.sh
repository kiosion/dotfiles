#!/bin/sh

# .config
ln -s .config/*/ ~/*/

# Xorg stuff
ln -s .xinitrc ~/.xinitrc
ln -s .xresources ~/.xresources

# Vim
ln -s vim/.vim/* ~/.vim/*
ln -s vim/* ~/*
