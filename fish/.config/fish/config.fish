source /usr/share/cachyos-fish-config/cachyos-config.fish
# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# Initialize zoxide
zoxide init fish | source
# initialize mise
mise activate fish | source

# Aliases
# Replace ls with eza
# alias ls='eza -al --color=always --group-directories-first --icons' # preferred listing
# alias la='eza -a --color=always --group-directories-first --icons'  # all files and dirs
# alias ll='eza -l --color=always --group-directories-first --icons'  # long format
# alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
# alias l.="eza -a | grep -e '^\.'"                                     # show only dotfiles

if status is-interactive
    if not set -q ZELLIJ
        exec zellij
    end
end
