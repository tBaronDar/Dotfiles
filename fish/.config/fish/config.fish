source /usr/share/cachyos-fish-config/cachyos-config.fish
# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

if status is-interactive
    if not set -q ZELLIJ
        exec zellij
    end
end

# Initialize zoxide
zoxide init fish | source
# initialize mise
mise activate fish | source

# Aliases
alias d-stop='docker stop $(docker ps -q)'
alias tunnel-startup="docker compose -f /home/themis/Coding/tools/cloudflare-tunnel/docker-compose-tunnel.yml up -d"
