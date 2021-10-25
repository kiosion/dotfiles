#!/bin/sh

# get path
echo $0
full_path=$(realpath $0)
dir_path=$(dirname $full_path)

# .config
# TODO: recursively symlink components in .config

# Xorg stuff
ln -s $dir_path/.xinitrc ~/.xinitrc
ln -s $dir_path/.xresources ~/.xresources

# Vim
#mv .vim/ ~/.vim
