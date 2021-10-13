#!/bin/sh

echo "==> Installing pkgs list..."
paru -S --needed - < pkgs --noconfirm
