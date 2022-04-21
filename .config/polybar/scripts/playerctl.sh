#!/bin/sh

if playerctl -p spotify metadata --format '{{status}}' | grep -q 'Playing'
then
    out=`playerctl -p spotify metadata --format '{{artist}} - {{title}}'`
    out=' + '$out
    echo $out
else 
    if playerctl -p spotify metadata --format '{{status}}' | grep -q 'Paused'
    then
        out=`playerctl -p spotify metadata --format '{{artist}} - {{title}}'`
        out=' - '$out
        echo $out
    else
        echo " -"
    fi
fi
