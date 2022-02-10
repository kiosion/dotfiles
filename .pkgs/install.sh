#!/bin/sh

echo "==> Installing pkgs list..."
sudo paru -S --needed - < ./pkgs --noconfirm
