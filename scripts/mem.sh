#!/bin/bash

# Print mem usage for given PID
echo 0 $(awk '/Rss/ {print "+", $2}' /proc/$1/smaps) | bc | echo $(awk '{print $1}') MB
