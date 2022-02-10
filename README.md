## Dotfiles

Dotfiles are hidden files prefaced by '.' and used in personalizing your system and programs; here are mine :)

## What's inside (Linux)

<img src="img/arch.png"></img>[^1]

- [DE config](#de-config)
- [System files](#system-files)
- [Scripts](#scripts)
- [Themes](#themes)
- [Program configs](#program-configs)

### DE config
Instead of a desktop environment, I just use a tiling WM, hotkey daemon, and status bar. This way, there's less bloat and things are easier to tinker with :) 

#### [bspwm](https://github.com/baskerville/bspwm)
My current window manager is bspwm; I've tried others such as [Hypr](https://github.com/vaxerski/Hypr), but I've found bspwm to be the most stable and open to configuration.

#### [sxhkd](https://github.com/baskerville/sxhkd)
My hotkey daemon of choice is sxhkd, although there are many others.

#### [alacritty](https://github.com/alacritty/alacritty)
Alacritty is my favourite terminal emulator; I use it for its simplicity and how well it works under bspwm (not having an ugly title bar / status bar, for one).

#### [polybar](https://github.com/polybar/polybar)
For my status bar / virtual desktop switcher I use Polybar along with some scripts I've written for it.

#### [nitrogen](https://github.com/l3ib/nitrogen)
I use Nitrogen to set my desktop wallpaper in Xorg

### System files
Included here are also various system files for my pc - Stuff like my GRUB config, tweaks to systemd processes, and fstab.

### Scripts
I've also included some basic scripts / helpers I've written.

#### [backup.sh](https://github.com/kiosion/dotfiles/blob/master/scripts/backup)
This is a script I wrote to automate backing up my home directory, compressing it to a tarball using gzip, then moving it to my archival server using rsync. It uses pv in order to display a progress bar throughout this.

#### [logout.sh](https://github.com/kiosion/dotfiles/blob/master/scripts/logout)
A super-simple script that just kills Xorg and some other processes in order to exit to the TTY, assuming you created your session using Xinit.

### Themes
My themes for Polybar, bspwm, and other UI stuff.

### Program configs
Along with all that, there's config files for a bunch of programs I use regularly - Stuff like my VSC dotfiles, Chrome flags and theme, and Nemo configuration.

## What's inside (MacOS)

<img src="img/macos.png"></img>

- [WM config](#wm-config)
- [Scripts](#mac-scripts)
- [Program configs](#mac-program-configs)

Still #TODO :)

## Installation

The install script included is intended for my pc and *will* overwrite files as well as implement my grub and fstab configs. If there are bits of my config you like, clone the repo and manually move files, instead of using the install script.


[^1]: Wallpapers by the talented [Astero](https://www.artstation.com/pranetoid).
