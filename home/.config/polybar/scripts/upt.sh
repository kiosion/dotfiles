#!/bin/sh
	echo "$(uptime -p | sed s/up//g)"
