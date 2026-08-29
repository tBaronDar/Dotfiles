#!/bin/sh

set -e #stop on error

./install-yay.sh
./install-docker.sh
./install-mise.sh
./install-flatpak.sh
./install-stow.sh
./install-dbeaver.sh
./install-neovim.sh
./install-zellij.sh
# ./install-obsidian.sh
./install-eza.sh
./install-wl-clipboard.sh
./install-zoxide.sh
./install-superfile.sh
./install-lazygit.sh

# AUR
# ./install-cursor.sh

# flatpaks
./install-stremio.sh
# ./install-slack.sh
./install-spotify.sh

# dotfiles
./stow-packages.sh

# runs after stow-packages.sh: ~/.config/alacritty must already be the
# symlink into this repo before cloning into its themes/ subdir
./install-alacritty-themes.sh

# mise
mise install
