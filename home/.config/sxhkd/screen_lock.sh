#!/bin/sh

#rm /tmp/screen.png
#tmpbg='/tmp/screen.png'

# take a screenshot, size it down
#scrot "$tmpbg" && convert "$tmpbg" -thumbnail 50% "$tmpbg"
#convert "$tmpbg" -filter Gaussian -thumbnail 50% -sample 100% "$tmpbg" #-sample 500% "$tmpbg"

# set betterlockscreen's image
#betterlockscreen -u "$tmpbg" --fx blur

# lock display with betterlockscreen
betterlockscreen --lock blur
