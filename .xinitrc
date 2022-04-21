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
#

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap
xrdb ~/.Xresources

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

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# start keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,  ssh)

export SSH_AUTH_SOCK
export GPG_AGENT_INFO
export GNOME_KEYRING_CONTROL
export GNOME_KEYRING_PID

# start pantheon
#io.elementary.wingpanel &
#XDG_SESSION_TYPE=x11 plank &
#exec gala
# start bspwm
exec bspwm
# start hypr
#exec Hypr
# start awesome
#exec awesome
#exec dbus-launch --sh-syntax --exit-with-session bspwm
