#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then







    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then







    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# start bspwm
exec dbus-launch --sh-syntax --exit-with-session bspwm

# set name of wm (fixes IntelliJ IDEA and some other programs behaving weird)
exec wmname LG3D

# set env to also fix IntelliJ :)))))
export _JAVA_AWT_WM_NONREPARENTING=1

# start xfce4
#exec startxfce4

# start kde plasma
#export DESKTOP_SESSION=plasma
#exec startplasma-x11
