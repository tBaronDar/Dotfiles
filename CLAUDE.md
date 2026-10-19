# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). There is no build, lint, or test suite — this is configuration, not application code.

## Branches: one per machine — this is `work`

The repo has one long-lived branch per physical machine: `main` (personal CachyOS laptop), `pure` (fresh Arch + KDE), and `work` (macOS work machine). Branches are never merged into each other, and their package sets, scripts, and even this file diverge.

**This checkout is `work`. Only work on `work`; do not switch to or make changes for `main`/`pure`** (same rule as `.github/copilot-instructions.md`). If you need to know how something looks on another branch, read it without switching: `git show origin/main:<path>` / `git ls-tree --name-only origin/main`. Don't assume parity — e.g. `main` has `KDE`/`kitty`/`lazygit` packages and a CachyOS-based `config.fish` that `work` doesn't.

## `work` branch specifics (macOS)

- **Shells**: `fish` (primary) and `zsh` are both Homebrew-based — they set up `brew shellenv` / the keg-only openssl path, init `zoxide` and `mise` (plus `fzf` in fish), define `eza`-based `ls`/`la`/`ll`/`lt` aliases, and auto-launch `zellij` when `$ZELLIJ` is unset (keep that guard when touching startup). Each has a `sysupdate` function (`fish/.config/fish/functions/sysupdate.fish`, `zsh/.config/zsh/functions/sysupdate.zsh`) running `brew update`, `brew upgrade`, `mise upgrade` with early return on failure (`or return 1` / `|| return 1`) — prefer that pattern over `&&` chains for new multi-step functions.
- **Installer gap**: `install/*.sh` are copied unmodified from Linux (`pacman`, `yay`, `flatpak`, `systemctl`) and **do not run on macOS** — kept for reference only. Porting them to `brew` is the outstanding work. `install/stow-packages.sh` is the exception: plain POSIX `sh` (`stow`/`dirname`/`realpath`), works here as-is.
- **Alacritty**: `Shift+Return` sends `\u001B\r` (ESC+CR, for multi-line input in TUIs). The window title is still hardcoded `"Alacritty@CachyOS"`.
- **mise** (`mise/.config/mise/config.toml`): source of truth for this machine's global tool versions (java 21, node/npm latest, maven, `claude`, `copilot`, `npm:@playwright/mcp`, etc.). Differs from other branches by design.
- **Other packages**: `prettier` (stows a global `~/.config/prettierrc.json`), `ideavimrc` (JetBrains IdeaVim), `bashrc`, `git`, `nvim`, `zellij`.

## Stow packages

Every top-level directory except `install/` and `KDE/` (and dot-directories like `.github/`) is a Stow package whose contents mirror their location under `$HOME` — e.g. `nvim/.config/nvim` → `~/.config/nvim`.

```sh
./install/stow-packages.sh                     # stow every package (runnable from anywhere)
stow -d ~/Dotfiles -t "$HOME" <package>        # stow one package
stow -D -d ~/Dotfiles -t "$HOME" <package>     # unstow one package
```

`stow-packages.sh` auto-discovers packages (no edits needed when adding one). **It is destructive**: before stowing, it `rm -rf`s any pre-existing *real* (non-symlink) path in `$HOME` that a package owns, found by descending each package's top-level entries through single-subdirectory chains (e.g. `nvim/.config/nvim` → `~/.config/nvim`) so it never touches shared dirs like `~/.config`. Preserve that invariant when modifying it; when adding files to a package, check what that leaf-path walk will now resolve to.

## Install scripts (`install/`)

One thin script per tool; `master-install.sh` runs them with `set -e` by relative path, so run it from inside `install/`. When adding a tool, follow the one-script-per-tool pattern and put it in the right section of `master-install.sh`. Ordering matters: package installs → `stow-packages.sh` → `install-alacritty-themes.sh` (clones into `~/.config/alacritty/themes`, which must already be the stowed symlink; that path is gitignored to avoid a nested repo) → `mise install` last. Package removal isn't scripted.

Only available check: `sh -n install/*.sh` (syntax only — never execute the installers to test them).

## Neovim (`nvim/`)

LazyVim config: core options/keymaps/autocmds in `lua/config/`, one plugin spec per concern in `lua/plugins/`, enabled extras in `lazyvim.json`, plugin pins in `lazy-lock.json`, Lua formatted per `stylua.toml`. Notable specs:

- `project-formatters.lua`: conform.nvim prefers a project's own formatter — `.oxfmtrc.json` (oxfmt), then `biome.json`/`.biome.json` (biome), else prettier — for js/jsx/ts/tsx/css.
- `all-themes.lua` (multiple themes for runtime switching), `neo-tree.lua` (empty-buffer cleanup workaround), `markdown-lint.lua`, `groovyls.lua`, `snacks-picker.lua`, `disable-news-alert.lua`.

## Git (`git/`)

`.gitconfig` sets `core.excludesfile = ~/.gitignore_global` (stowed alongside as `git/.gitignore_global`), `push.autoSetupRemote = true`, and short aliases (`st`, `co`, `sw`, `lg`, …). Global ignore patterns go in `.gitignore_global`; the repo's own `.gitignore` covers only repo artifacts (cloned alacritty themes, fish's machine-generated `fish_variables`).
