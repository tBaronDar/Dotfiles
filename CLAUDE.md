# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles for Arch-based Linux (CachyOS), pure Arch, or MacOS managed
with [GNU Stow](https://www.gnu.org/software/stow/). There is no build, lint, or
test suite — this is configuration, not application code.

This file is identical across all branches (generic, machine-agnostic). Machine-specific detail lives in the "Branches" section below — read the subsection for whichever branch is checked out before assuming a package, script, or alias behaves the same way on another machine.

## Branches: one per machine

This repo tracks three branches, each the checkout for a specific physical machine — check out the matching branch on that machine rather than merging them together. Package sets, install scripts' correctness, and even alias/tool-version details diverge per branch; don't assume parity with another branch without checking.

`install/stow-packages.sh` auto-discovers whichever packages exist in the current checkout (see "Structure: Stow packages" below), so it doesn't need updating when packages are added or removed on a given branch.

### `main` — personal laptop

Arch-based (CachyOS). Both Hyprland (`hypr/`) and KDE Plasma (`KDE/shortcuts.kksrc`) configs are present. Also the only branch with `ideavimrc/` (JetBrains + IdeaVim).

- **Package installer**: `pacman` (core) + `yay` (AUR — `install-cursor.sh`, `install-eza.sh`) + `flatpak` (`install-stremio.sh`, `install-slack.sh`, `install-spotify.sh`). `install/master-install.sh` is unmodified and fully functional here.
- **Terminal**: Alacritty (only terminal package in the repo). This branch's `alacritty.toml` has one binding not present on `work`/`pure`: `Shift+Return` sends a literal newline (`chars = "\r"`).
- **Packages**: `KDE`, `alacritty`, `bashrc`, `fish`, `git`, `hypr`, `ideavimrc`, `install`, `mise`, `nvim`, `zellij`.

### `work` — work Mac

macOS. **Known gap — not yet actually adapted for macOS**: this branch still carries Linux-only artifacts inherited from `main`/`pure`, none of which function on macOS as committed:
- `hypr/` — Hyprland is a Wayland compositor, Linux-only, cannot run on macOS.
- `fish/.config/fish/config.fish` still does `source /usr/share/cachyos-fish-config/cachyos-config.fish` — a CachyOS-only path.
- `install/*.sh` are unmodified `pacman`/`yay` scripts.

- **Package installer**: intended to be Homebrew (`brew`), but not yet implemented — `install/*.sh` need a macOS rewrite (`brew install <pkg>` in place of `pacman`/`yay`/`flatpak`) before `master-install.sh` will actually work here. `install/stow-packages.sh` itself needs no porting — it's plain POSIX `sh` using only `stow`/`dirname`/`realpath`, all available via Homebrew/macOS base.
- **Terminal**: Alacritty is the only terminal package stowed (same as other branches). `alacritty.toml` differs from `main`/`pure` only by lacking the Shift+Return binding; the window title is still hardcoded `"Alacritty@CachyOS"`.
- **Shell**: `fish`'s `update` alias is `yay -Syu` (vs. pacman+flatpak+mise on `main`/`pure`) — also not yet adapted to `brew`.
- **mise**: `mise/.config/mise/config.toml` pins `node = "25"` (exact, vs `"latest"` elsewhere), has `npm = "latest"` active (commented out on `main`/`pure`), and has no `claude` tool entry at all — reflects what's actually installed on this machine today, not yet reconciled with the other branches.
- **Packages**: `alacritty`, `bashrc`, `fish`, `git`, `hypr`, `ideavimrc`, `install`, `mise`, `nvim`, `zellij` (no `KDE`).

### `pure` — fresh/pure Arch install

Arch Linux + KDE Plasma (`KDE/shortcuts.kksrc`). No `hypr/`, no `ideavimrc/` — deliberately trimmed (see commit "removed hyperland config files and ideavimrc").

- **Package installer**: `pacman` + `yay` (AUR) + `flatpak` — same as `main`. `install/master-install.sh` is the reference implementation these scripts were written for, and is fully functional as committed (unlike `work`).
- **Terminal**: Alacritty — `alacritty.toml` identical to `main`.
- **Packages**: `KDE`, `alacritty`, `bashrc`, `fish`, `git`, `install`, `mise`, `nvim`, `zellij`.

## Structure: Stow packages

Each top-level directory except `install/` and `KDE/` is a Stow "package" whose contents mirror the layout it should have relative to `$HOME`. For example, `alacritty/.config/alacritty/alacritty.toml` stows to `~/.config/alacritty/alacritty.toml`. Which packages exist depends on the branch/machine — see "Branches" above (e.g. `hypr` and `ideavimrc` only exist on `main`/`work`).

`install/stow-packages.sh` stows every package present in the current checkout automatically (see "Install scripts" below) — run it directly, or as the last step of `master-install.sh`. To deploy/remove a single package by hand instead:

```sh
stow -d <repo-root> -t "$HOME" <package>       # e.g. stow -d ~/Dotfiles -t "$HOME" fish
stow -D -d <repo-root> -t "$HOME" <package>    # unstow / remove the symlinks
```

`KDE/shortcuts.kksrc` is not stowed (no `.config`-mirroring subpath); it's a KDE shortcuts export kept for reference/manual import, and is excluded from `stow-packages.sh`'s discovery.

## Install scripts (`install/`)

Standalone `sh` scripts, one per tool, mostly thin `pacman -S --needed --noconfirm <pkg>` wrappers (a few use `yay` for AUR packages or `flatpak install`) — this pattern is only correct on `main`/`pure`; see "Branches" above for `work`'s macOS gap. `install/master-install.sh` runs all of them in sequence with `set -e`. When adding a new tool, follow the existing one-script-per-tool pattern and append it to `master-install.sh` in the right group (core tools vs. the `# AUR` / `# flatpaks` sections near the bottom).

`install/stow-packages.sh` is the last step of `master-install.sh`: it discovers every top-level directory in the repo except `install/` and `KDE/` (and anything that isn't a real directory) and runs `stow -v -d <repo-root> -t "$HOME"` on each one, so one `master-install.sh` run both installs packages and symlinks all dotfiles for the current branch/machine. It resolves the repo root from its own script location, so it also works run standalone from anywhere. It uses plain `stow` with no `--adopt`/`-R` flags: if a target already exists in `$HOME` and isn't a symlink (e.g. a stock `.bashrc` from `/etc/skel` on a fresh install), stow stops and prints exactly what's in the way, and you resolve it by hand rather than the script silently overwriting or adopting it. It requires `stow` to already be installed — `install-stow.sh` runs earlier in `master-install.sh`. Unlike the package-installer scripts, it's plain POSIX `sh` with no distro-specific commands, so it works unmodified on every branch, including `work`.

Package _removal_ isn't handled by any script yet — a natural future addition, but out of scope for now.

## Shell setup (`fish/`)

- `fish/.config/fish/config.fish` layers on top of `cachyos-fish-config` (sourced first). It initializes `zoxide` and `mise`, defines aliases, and auto-launches `zellij` on interactive shell start if not already inside one. Note: the `cachyos-fish-config` source line is CachyOS-specific — see `work`'s known gap under "Branches" above.
- Custom functions live in `fish/.config/fish/functions/` (one file per function, e.g. `sysupdate.fish`). `sysupdate` wraps `pacman -Syu`, `flatpak update`, and `mise upgrade` with early-return on failure (`or return 1`) — prefer this pattern over `&&` chaining for new multi-step functions so partial failures are visible.
- `fish/.config/fish/conf.d/` holds tool-specific fish snippets loaded automatically at shell start (e.g. `rustup.fish`).
- The `update` alias is branch-specific — see "Branches" above for the exact command on each machine.

## Neovim (`nvim/`)

LazyVim-based config (`nvim/.config/nvim/lua/config/` for core options/keymaps/autocmds, `nvim/.config/nvim/lua/plugins/` for plugin specs, one file per concern). Enabled LazyVim extras are tracked in `lazyvim.json`.

Notable custom plugin specs:

- `plugins/project-formatters.lua`: makes `conform.nvim` prefer a project's own formatter over LazyVim's default prettier — checks for `.oxfmtrc.json` (oxfmt) then `biome.json`/`.biome.json` (biome) before falling back to prettier, for js/jsx/ts/tsx/css.
- `plugins/omarchy-theme-hotreload.lua`, `plugins/all-themes.lua`: theme integration/hot-reload.
- `plugins/disable-news-alert.lua`: suppresses LazyVim's news popup.

## Git config (`git/`)

`git/.gitconfig` sets `core.excludesfile = ~/.gitignore_global` (stowed alongside it as `git/.gitignore_global`) and `push.autoSetupRemote = true`. Add new global ignore patterns to `.gitignore_global`, not to individual project `.gitignore` files, unless the pattern is project-specific.

## mise (`mise/`)

`mise/.config/mise/config.toml` pins global tool versions for whatever branch/machine is checked out. The pinned tool list and versions currently differ between branches — see "Branches" above (e.g. `work` lacks `claude`, pins `node` to an exact version, and has `npm` active where `main`/`pure` comment it out). Treat it as the source of truth for that machine's global language/tool versions, not as identical across machines.
