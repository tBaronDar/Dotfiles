#!/bin/sh

set -e #stop on error

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

    # Before stowing, clear out any pre-existing real (non-symlink) file or
    # directory in $HOME that this package owns (e.g. default configs left
    # by a fresh install), so it gets replaced by the repo's version instead
    # of blocking stow. For each top-level entry in the package, descend
    # while it's a directory with exactly one subdirectory (e.g.
    # nvim/.config/nvim -> .config/nvim) to find the package's own leaf
    # config path without ever reaching a shared directory like ~/.config.
    # Plain "*" doesn't match dotfiles (.config, .bashrc, ...), which is
    # exactly what every package's top-level entries are, so glob for those
    # too.
    for child in "$package"/* "$package"/.[!.]* "$package"/..?*; do
        [ -e "$child" ] || continue

        while [ -d "$child" ]; do
            set -- "$child"/* "$child"/.[!.]* "$child"/..?*
            entries=0
            single=""
            for entry in "$@"; do
                [ -e "$entry" ] || continue
                entries=$((entries + 1))
                single=$entry
            done
            if [ "$entries" -eq 1 ] && [ -d "$single" ]; then
                child=$single
            else
                break
            fi
        done

        relpath=${child#"$package"/}
        target="$HOME/$relpath"
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            echo "    removing pre-existing $target"
            rm -rf -- "$target"
        fi
    done

    stow -v -d "$repo_root" -t "$HOME" "$package"
done
