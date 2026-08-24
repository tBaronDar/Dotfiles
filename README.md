# Configuration dot files

This repository contains personal configuration dotfiles for Arch-based Linux
(CachyOS), pure Arch, or MacOS, managed with [GNU Stow](https://www.gnu.org/software/stow/). The repository is structured to allow easy deployment of these configurations across different machines and operating systems.

## Themes good combos

Tested color combinations for terminal, multiplexer, and editor:

| zellij   | alacritty    | Neovim    |
| -------- | ------------ | --------- |
| nightfox | synthwave_84 | hackerman |

## Terminals

Alacritty

- Philosophy: does one thing — render a terminal — as fast as possible, and nothing else. No tabs, no splits, no built-in scrollback search UI beyond basics, no image support, no plugin system.
- Config: TOML, small surface area, mostly colors/fonts/keybindings/window opts. You currently have this stowed (alacritty/.config/alacritty/alacritty.toml).
- Why people pick it: lowest input latency and simplest mental model. You're expected to pair it with a multiplexer for tabs/splits — which is exactly what you're doing with zellij auto-launching on shell start. Ligature support exists but historically was an afterthought; it does not support the Kitty or Sixel graphics protocols, so image previews (icat, chafa in kitty-protocol mode, etc.) don't render inline.
- Downside: because it does so little, everything else (tabs, panes, session persistence, images) is someone else's job.
  — a lot of what people reach for tmux/zellij for is built in.

Kitty

- Philosophy: batteries-included terminal — a lot of what people reach for tmux/zellij for is built in.
- Features: native tabs and window splits/layouts, its own Kitty graphics protocol (now a de facto standard many CLI tools support for inline images/previews), ligatures, a fast scrollback search, and "kittens" — small bundled programs/plugins (SSH kitten that carries your terminfo and config over SSH cleanly, a diff kitten, a hints kitten for jumping to URLs/paths by keyboard, unicode input, etc.). Also has a remote-control protocol so scripts/other programs can drive a running kitty instance (open new tabs, send text, etc.) — useful for tooling/automation.
- Config: plain-text kitty.conf, very extensive (fonts, per-OS window decorations, cursor behavior, shell integration).
- Why people pick it: you get tabs/splits/images without layering a multiplexer on top, plus scriptability. Trade-off: if you already use zellij, kitty's own tabs/splits are redundant — you'd likely disable them and use it as "just" a fast terminal, similar to Alacritty.

Ghostty

- Philosophy: newer (Mitchell Hashimoto, 2024), aims for "it just works, natively" — sane defaults, minimal config needed out of the box, but with splits/tabs built in like kitty.
- Standout feature: uses the actual native UI toolkit of the OS instead of a custom-drawn window — real macOS tabs/window chrome on macOS, GTK4/libadwaita on Linux — so it looks and behaves like a first-class native app (window snapping, native tab bar, system accessibility) rather than a terminal-shaped rectangle. Alacritty and Kitty draw their own chrome/tabs.
- Features: splits/tabs, Kitty-graphics-protocol compatibility (so tools built for kitty's image protocol work), ligatures, shell integration (cursor shape per mode, working-directory tracking, marking prompts so you can jump between them), and supports the same custom GLSL shader post-processing Alacritty added (CRT/glow effects etc.).
- Config: simple key = value text file, deliberately smaller surface than kitty's.
- Why people pick it: want kitty-like built-in features but with native OS look/feel and less config tuning to get there.
