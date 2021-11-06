#!/bin/sh

# Move fstab into place
sudo mv fstab /etc/fstab

# Move systemd overrides into place
sudo mkdir /etc/systemd/system/getty@tty1.service.d && sudo mv systemd/getty@tty1.service.d/* /etc/systemd/system/getty@tty1.service.d/*
