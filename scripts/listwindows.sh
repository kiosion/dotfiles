#!/usr/bin/env fish

for i in (bspc query -N -n .window); echo $i - (xdotool getwindowname $i) - (xdotool getwindowclassname $i); end
