# Copilot instructions

## Repository shape

Copilot works only on the `work` branch in this repository. The `work` branch
will never be merged to any other branch. Do not switch to or make changes for
`main` or `pure`.

This is a personal dotfiles repository, not an application. Top-level
configuration directories are GNU Stow packages: their contents mirror the
paths they install below `$HOME` (for example,
`nvim/.config/nvim` becomes `~/.config/nvim`). `install/` contains setup
scripts and is not a Stow package. `KDE/shortcuts.kksrc` is a manual KDE
shortcuts export and is also intentionally excluded from automatic stowing.

The `work` branch is the macOS work-machine configuration. It contains
Homebrew-oriented shell setup, but its `install/*.sh` scripts still use Linux
`pacman`, `yay`, `flatpak`, and `systemctl` commands; do not assume the
installer is macOS-compatible.

## Installation and deployment

> [!NOTE]
> The following scripts have been copied from a linux system thus the will not
> run on macOS. They are included for reference only.

Run the full installer from the `install` directory because
`master-install.sh` invokes sibling scripts by relative path:

```sh
cd install
./master-install.sh
```

To deploy only configuration packages, run this from any directory:

```sh
./install/stow-packages.sh
```

`stow-packages.sh` resolves the repository root from its own location,
discovers all top-level directories except `install/` and `KDE/`, removes
pre-existing real files/directories at package-owned leaf paths, and then
stows each package into `$HOME`. Preserve this behavior when modifying the
script; it must not remove shared paths such as `~/.config`. The
`stow-packages.sh` works unmodified on all branches.

When adding an installable tool, use the existing one-script-per-tool pattern
under `install/` and add the script to the appropriate section of
`master-install.sh`. Keep the ordering meaningful: dependencies and package
installation come before Stow, the Alacritty theme clone comes after Stow,
and `mise install` runs last. The Alacritty themes directory is a cloned
repository under a stowed symlink and is deliberately ignored by the parent
repository.

## Shell configuration

The `fish/` and `zsh/` packages configure Homebrew paths, `zoxide`, `mise`,
`fzf` (fish), aliases based on `eza`, and a `sysupdate` function. Interactive
shells automatically start Zellij when they are not already inside a Zellij
session; keep that guard when changing startup behavior. Fish and Zsh
`sysupdate` functions update Homebrew and mise with early returns on failure.
Machine-generated Fish universal variables are not hand-maintained.

## Neovim configuration

Neovim is a LazyVim setup bootstrapped by `init.lua` and
`lua/config/lazy.lua`. Put general options, keymaps, and autocommands under
`lua/config/`; add or override plugins as separate specs under `lua/plugins/`.
Enabled LazyVim extras are declared in `lazyvim.json`, and plugin versions are
tracked in `lazy-lock.json`.

Custom behavior includes persisted colorscheme selection, loading multiple
themes for runtime switching, markdown lint/format configuration, and a
Neo-tree empty-buffer cleanup workaround. Preserve these integrations when
updating related plugin specs. Use the repository's existing formatting style
for Lua (the config includes `stylua.toml`).

## Validation

There is no project build, test suite, or top-level lint command. For changes
to shell scripts, check POSIX syntax without executing installers:

```sh
sh -n install/*.sh
```

For Stow changes, inspect the package targets before applying them; the
deployment script can remove existing non-symlink targets that a package owns.
For Neovim changes, validate by starting Neovim and checking the LazyVim
health/plugin state on the target machine.

## Documentation

`README.md` contains the project overview and terminal/theme notes. Keep this
file aligned with the current `work` branch when its behavior changes.
