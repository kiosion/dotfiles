#!/bin/sh

stat=`playerctl metadata --format '{{status}}'`

if playerctl metadata --format '{{status}}' | grep -q 'Playing'
then
    out=`playerctl metadata --format '{{artist}} - {{title}}'`
    out=' + '$out
    echo $out
else 
    if playerctl metadata --format '{{status}}' | grep -q 'Paused'
    then
        out=`playerctl metadata --format '{{artist}} - {{title}}'`
        out=' - '$out
        echo $out
    else
        echo " -"
    fi
fi
