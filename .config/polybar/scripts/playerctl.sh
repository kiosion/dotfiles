#!/bin/sh

if playerctl -i firefox metadata --format '{{status}}' | grep -q 'Playing'
then
    out=`playerctl -i firefox metadata --format '{{artist}} - {{title}}'`
    out=' + '$out
    echo $out
else 
    if playerctl -i firefox metadata --format '{{status}}' | grep -q 'Paused'
    then
        out=`playerctl -i firefox metadata --format '{{artist}} - {{title}}'`
        out=' - '$out
        echo $out
    else
        echo " -"
    fi
fi
