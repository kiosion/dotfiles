#!/usr/bin/env perl

## The sink we are interested in should be the default 
my $sink = `pactl get-default-sink`;

## Run pactl and store output 
open(my $fh, '-|', 'pactl list sinks');

## Set the record separator to consecutive newlines (same as -000)
## this means we read the info for each sink as a single "line".
$/="\n\n";
    
## Go thru the pactl output
while (<$fh>) {
    ## If this is the sink we want
    if (/Name:.$sink/) {
        ## Extract the current colume of this sink
        /Volume:.*?(\d+)%/;
        my $volume=$1;
        ## Extract the name of this sink
        /Description: (.*)/;
        my $name=$1;
        ## Send the notification, using gdbus so we can specify the 
        ## ID to update on repeat
        exec "gdbus call --session --dest org.freedesktop.Notifications --object-path /org/freedesktop/Notifications --method org.freedesktop.Notifications.Notify 'identifier' '999' '' 'Volume' '$volume%' '[]' '{\"value\": <$volume>}' '4000'";
    }
}
