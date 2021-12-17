## Dotfiles

Dotfiles are how you personalize your system and programs, typically prefaced with a '.' and hidden by default. I uploaded my most common config files and scripts here both to use when distro-hopping, and in case anyone wanted to use my configs as starting points :)

<img src="img.png"></img>[^1]


## What's inside

- [My DE config](#my-de-config)
- [System files](#system-files)
- [Scripts](#scripts)
- [Themes](#themes)
- [Program configs](#program-configs)

### My DE config
Currently, I don't use a desktop environment, just a tiling WM plus a hotkey daemon and status bar. 
#### [bspwm](https://github.com/baskerville/bspwm)
My current WM is bspwm, however I plan on switching to [XMonad](https://github.com/xmonad/xmonad) and will include those config files here as well once I do!

#### [sxhkd](https://github.com/baskerville/sxhkd)
The second bit of my desktop configuration is my hotkey daemon of choice, sxhkd.

#### [polybar](https://github.com/polybar/polybar)
For my status bar / virtual desktop switcher I currently use the versitile & minimal Polybar, along with some  scripts and helpers written for it.

#### [nitrogen](https://github.com/l3ib/nitrogen)
I use nitrogen to set my desktop wallpaper. No config required and super easy to use :)

### System files
Included here are also various system files for specifically my computer - Stuff like my GRUB config, tweaks to various systemd processes, my fstab configuration, etc.

### Scripts
I've also included a bunch of quality-of-life scripts and helpers I've written for various functions. From things like a volume widget for [Polybar](https://github.com/polybar/polybar) to my fullscreen [Rofi](https://github.com/davatorium/rofi) theme.

### Themes
Themes I've written for Polybar, bspwm, and other UI stuff.

### Program configs
Along with all that, there's config files for a bunch of programs I use regularly - Stuff like my Visual Studio Code dotfiles, my Chrome flags setup, Nemo configuration, etc.

## Installation

Please note, this script is intended for specifically my computer and will overwrite files as well as implement my grub and fstab configs. Customize it first and use caution if running under an already-configured install.

Run:
```
git clone https://github.com/kiosion/dotfiles.git ~/.dotfiles && \
cd ~/.dotfiles && \
chmod +x script/install && \
sudo script/install
```
*( Work in progress, for now, you can simply manually move files into place :p )*
[^1]: Wallpaper by the talented [Astero](https://www.artstation.com/pranetoid).
