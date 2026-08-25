# Homebrew (Apple Silicon vs Intel prefix)
if test -d /opt/homebrew
    eval "$(/opt/homebrew/bin/brew shellenv)"
else if test -d /usr/local/Homebrew
    eval "$(/usr/local/bin/brew shellenv)"
end

# openssl is keg-only, so brew shellenv doesn't put it on PATH
if set -q HOMEBREW_PREFIX
    fish_add_path "$HOMEBREW_PREFIX/opt/openssl/bin"
end

# Initialize zoxide
zoxide init fish | source
# initialize mise
mise activate fish | source

# Aliases
# Replace ls with eza
alias ls='eza -al --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons' # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons' # long format
alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
alias l.="eza -a | grep -e '^\.'" # show only dotfiles

if status is-interactive
    if not set -q ZELLIJ
        zellij
        exit
    end

    fastfetch
end
