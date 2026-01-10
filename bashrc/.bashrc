# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
#
export APPSERV=/home/themis/Work/appserv/
export CAPSTONE=/home/themis/ESD/2nd-semester/capstone/
export TOOLS=/home/themis/Coding/tools/
export RUST=/home/themis/Coding/rust/

# Aliases
alias d-stop='docker stop $(docker ps -q)'
alias tunnel-startup="docker compose -f /home/themis/Coding/tools/cloudflare-tunnel/docker-compose-tunnel.yml up -d"

. "$HOME/.local/share/../bin/env"
. "$HOME/.cargo/env"
