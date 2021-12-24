## Dotfiles

Dotfiles are how you personalize your system and programs, typically prefaced with a '.' and hidden by default. I uploaded my most common config files and scripts here both to use when distro-hopping, and in case anyone wanted to use my configs as starting points :)

<img src="img.png"></img>
<img src="img2.png"></img>[^1]
 

## What's inside

- [My DE config](#my-de-config)
- [System files](#system-files)
- [Scripts](#scripts)
- [Themes](#themes)
- [Program configs](#program-configs)

### My DE config
Currently, I don't use a desktop environment, just a tiling WM plus a hotkey daemon and status bar. 
#### [bspwm](https://github.com/baskerville/bspwm)
My current window manager is bspwm, however I plan on eventually switching to [XMonad](https://github.com/xmonad/xmonad) and will include those config files here as well once I do!

#### [sxhkd](https://github.com/baskerville/sxhkd)
The second bit of my desktop configuration is my hotkey daemon of choice, sxhkd.

#### [polybar](https://github.com/polybar/polybar)
For my status bar / virtual desktop switcher I currently use Polybar, along with some scripts I've written for it.

#### [nitrogen](https://github.com/l3ib/nitrogen)
I use Nitrogen to set my desktop wallpaper. No configuration required and super easy to use :)

### System files
Included here are also various system files for my pc specifically - Stuff like my GRUB config, tweaks to various systemd processes, fstab configuration, etc.

### Scripts
I've also included a bunch of quality-of-life scripts and helpers I've written. Things like a volume widget for [Polybar](https://github.com/polybar/polybar) and my fullscreen [Rofi](https://github.com/davatorium/rofi) theme.

### Themes
Themes I've written for Polybar, bspwm, and other UI stuff.

### Program configs
Along with all that, there's config files for a bunch of programs I use regularly - Stuff like my Visual Studio Code dotfiles, my Chrome flags setup, Nemo configuration, etc.

## Installation

This script is intended for my pc and *will* overwrite files as well as implement my grub and fstab configs, etc. Customize it first and use caution if running under an already-configured install.

Run:
```
git clone https://github.com/kiosion/dotfiles.git ~/.dotfiles && \
cd ~/.dotfiles && \
chmod +x script/install && \
sudo script/install
```
*( Work in progress, for now, just manually move files into place :p )*
[^1]: Wallpapers by the talented [Astero](https://www.artstation.com/pranetoid).
