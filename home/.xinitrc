#!/bin/sh
# _______________________________________________________        
#  _______________________________________________________       
#   ________________/\\\________________/\\\_____/\\\______      
#    __/\\\____/\\\_\///___/\\/\\\\\\___\///___/\\\\\\\\\\\_     
#     _\///\\\/\\\/___/\\\_\/\\\////\\\___/\\\_\////\\\////__    
#      ___\///\\\/____\/\\\_\/\\\__\//\\\_\/\\\____\/\\\______   
#       ____/\\\/\\\___\/\\\_\/\\\___\/\\\_\/\\\____\/\\\_/\\__  
#        __/\\\/\///\\\_\/\\\_\/\\\___\/\\\_\/\\\____\//\\\\\___ 
#         _\///____\///__\///__\///____\///__\///______\/////____
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

#xrandr --auto


# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

#export AWT_TOOLKIT=MToolkit

# start bspwm
exec dbus-launch --sh-syntax --exit-with-session bspwm

# disable mouse accel EW EW EW
exec ./fixmouse.sh

export _JAVA_AWT_WM_NONREPARENTING=1
