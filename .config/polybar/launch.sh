#! /bin/sh
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
polybar wide 2>&1 | tee -a /tmp/polybar1.log & disown
