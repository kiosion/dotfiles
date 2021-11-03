#!/bin/sh

# .config
# TODO: recursively symlink components in .config and other dirs

# Xorg stuff
ln -s .xinitrc ~/.xinitrc
ln -s .xresources ~/.xresources

# Vim
ln -s vim/.vim/* ~/.vim/*
ln -s vim/.vimrc ~/.vimrc
ln -s vim/.viminfo ~/.viminfo
