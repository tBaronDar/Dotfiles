#!/bin/sh

set -e #stop on error, e.g. a real (non-symlink) file already in $HOME blocking stow

# Resolve the repo root as the parent of this script's own directory, so
# this works no matter where it's run from (standalone or via
# master-install.sh, which cd's into install/ first).
repo_root=$(dirname -- "$(dirname -- "$(realpath -- "$0")")")

cd "$repo_root"

for package in */; do
    package=${package%/}
    [ -d "$package" ] || continue # skip if the glob didn't match anything

    # Only stow real packages: skip install/ (setup scripts, not a stow
    # package) and KDE/ (kept for manual import, see CLAUDE.md).
    case "$package" in
        install | KDE) continue ;;
    esac

    echo "==> stow $package"
    stow -v -d "$repo_root" -t "$HOME" "$package"
done
