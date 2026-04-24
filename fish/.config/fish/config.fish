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
alias d-stop='docker stop (docker ps -q)'
alias tunnel-startup="docker compose -f /home/themis/Coding/tools/cloudflare-tunnel/docker-compose-tunnel.yml up -d"
alias ls='eza -lh --group-directories-first --icons --hyperlink'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'

if status is-interactive
    if not set -q ZELLIJ
        exec zellij
    end
end
