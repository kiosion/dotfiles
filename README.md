## Dotfiles

Dotfiles are how you personalize your system and programs, these are mine! :)

I was tired of having everything unorganized, and slightly different on all my devices. That inspired me to upload my most common config files here, both to use when distro-hopping and in case anyone wanted to use my configs as starting points!

<img src="ss.png"></img>


## What's inside

A lot. Check them out in the file browser above to see what components may work for you.

## Components
I've tried to split this repo into individual components, to make it easier on myself to install, and to make it more modular for customising.

    bin/: Anything in bin/ will be added to $PATH and be made available everywhere.
    home/: Various files from my home directory
    misc/: Some subdirectories containing misc system files.
    system/: System files... grub, my fstab, etc
    pkgs/pkgs: Output of `paru -Q`, to be installed automatically after paru's built.
    */: Individual programs / components to be installed using their install.sh files.

## Install

Run this:
```
git clone https://github.com/kiosion/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
```
*( Work in progress, I'm adapting [holman's install script](https://github.com/holman/dotfiles/blob/master/script/bootstrap) to work for my setup and preferred shell. For now, you can simply manually move files into place :p )*
