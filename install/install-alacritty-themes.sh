#!/bin/sh

set -e

themes_dir="$HOME/.config/alacritty/themes"

if [ -d "$themes_dir/.git" ]; then
	git -C "$themes_dir" pull
else
	git clone https://github.com/alacritty/alacritty-theme "$themes_dir"
fi
