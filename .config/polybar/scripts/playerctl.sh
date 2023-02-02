#!/bin/sh

anim=( '-_-' '^_^' '^_^' '^_^' )

while true; do
    if playerctl -i firefox metadata --format '{{status}}' | grep -q 'Playing'
    then
        out=`playerctl -i firefox metadata --format '{{artist}} - {{title}}'`
        # Loop through the animation array a few times so we don't constantly hit playerctl
        for i in {1..4}
        do
            for i in "${anim[@]}"
            do
                echo "$i $out"
                sleep 0.4
            done
        done
    else
        if playerctl -i firefox metadata --format '{{status}}' | grep -q 'Paused'
        then
            out=`playerctl -i firefox metadata --format '{{artist}} - {{title}}'`
            echo "._. $out"
            sleep 1
        else
            echo "-_-"
            sleep 1
        fi
    fi
done
