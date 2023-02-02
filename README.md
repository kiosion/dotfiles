<h1 align="center">Dotfiles</h1>

Most of the configs and script files I've created for my desktop Linux + BSD machines and macOS laptop.
* [Linux](#linux-config)
* [MacOS](#macos-config)
* [Install](#installation)

<h2 align="center">Linux config</h2>

<img src="https://user-images.githubusercontent.com/34040324/216383754-1b447a17-a886-4fbe-8501-b57caa333edb.png" />

<img src="https://user-images.githubusercontent.com/34040324/216385619-dc8f1d45-ffde-4309-b3c5-3c43a38e778f.png" width="46%" /> <img src="https://user-images.githubusercontent.com/34040324/216384939-e2c94cfa-381f-4d79-9907-a30c3c8cc5f3.png" width="53%" />

I'm currently using Arch Linux as my main distro, with xorg + bspwm + sxhkd as my main interface. For my VMs and as my OS of choice for servers, I use FreeBSD, so there's also a few configs in here for it.

### What's included here
- [DE config](#de-config)
- [System files](#system-files)
- [Scripts](#scripts)
- [Themes](#themes)
- [Program configs](#program-configs)
- [Packages](#packages)

### DE config
Instead of a desktop environment I use a tiling wm, hotkey daemon, and status bar. This way there's less bloat and things are easier to tinker with. 

* #### [bspwm](https://github.com/baskerville/bspwm)

* #### [sxhkd](https://github.com/baskerville/sxhkd)

* #### [alacritty](https://github.com/alacritty/alacritty)

* #### [polybar](https://github.com/polybar/polybar)

* #### [nitrogen](https://github.com/l3ib/nitrogen)

* #### [rofi](https://github.com/davatorium/rofi)

* #### [wired](https://github.com/Toqozz/wired-notify)

### [System files](https://github.com/kiosion/dotfiles/blob/master/.arch/)
Included are various system files for my pc - Stuff like my GRUB config, fstab, and tweaks to systemd processes.

### [Scripts](https://github.com/kiosion/dotfiles/blob/master/scripts/)
I've also included some basic scripts / helpers I've written, both for Polybar and various system things.

* #### [backup](https://github.com/kiosion/dotfiles/blob/master/scripts/backup.sh)

* #### [fixmouse](https://github.com/kiosion/dotfiles/blob/master/scripts/fixmouse.sh)

* #### [vol](https://github.com/kiosion/dotfiles/blob/master/scripts/vol.sh)

### Themes
My themes for Polybar, bspwm, Rofi, and other UI stuff.

### [Program configs](https://github.com/kiosion/dotfiles/blob/master/.config/)
Along with all that, there's config files for a bunch of programs I use regularly - VSC, Firefox, Nemo, Alacritty, etc.

### [Packages](https://github.com/kiosion/dotfiles/blob/master/.pkgs/paru/)
Mostly for my own convienence, but I've also included a complete list of every package and program installed using Paru on my system, both from the core Arch repos and from the AUR.


<h2 align="center">MacOS config</h2>

<img src="img/macos.png" />

### What's included here
- [WM config](#wm-config)
- [Program configs](#program-configs-1)
- [Packages](#packages-1)

### WM config
On MacOS, I use the default desktop environment but have some additional programs/tweaks to make it slightly more linux-like.

* #### [yabai](https://github.com/koekeishiya/yabai)

* #### [skhd](https://github.com/koekeishiya/skhd)

* #### [ubersicht](http://tracesof.net/uebersicht/)

### [Program configs](https://github.com/kiosion/dotfiles/blob/master/.macos/.config/)
I've also included some various configs / install scripts for programs and utilities I use on MacOS.

### [Packages](https://github.com/kiosion/dotfiles/blob/master/.pkgs/brew/)
Like with my linux dotfiles, I've also included a full list of every formulae and cask installed with Homebrew.


<h2 align="center">Installation</h2>

The install scripts included in each OS dir are intended for my own use. Just clone this repo and either reverse-symlink, or copy files you want to use into place :p

Run: `git clone git@github.com:kiosion/dotfiles.git kio-dotfiles/`
