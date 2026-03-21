#!/bin/sh
sudo pacman -S --needed --noconfirm docker docker-compose
# activate daemon
sudo systemctl enable --now docker
# allow user to run docker without sudo
sudo usermod -aG docker $USER
