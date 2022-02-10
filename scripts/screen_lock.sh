#!/bin/sh
rm -f /tmp/screen.png
tmpbg='/tmp/screen.png'

# take a screenshot, set as betterlockscreen's image
scrot "$tmpbg"
betterlockscreen -u "$tmpbg" --fx blur

# lock display
betterlockscreen --lock blur
