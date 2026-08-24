#Path setup
export PATH="${HOMEBREW_PREFIX}/opt/openssl/bin:$PATH"
# export DYLD_LIBRARY_PATH="$(brew - prefix)/lib:$DYLD_LIBRARY_PATH"
autoload -Uz compinit && compinit

#start zoxide
eval "$(zoxide init zsh)"
#start mise
eval "$(mise activate zsh)"

# Functions
source ~/.config/zsh/functions/sysupdate.zsh

#Aliases
# Replace ls with eza
alias ls='eza -al --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons'  # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons'  # long format
alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
alias l.="eza -a | grep -e '^\.'"                                     # show only dotfiles

# Apps and programms
#alias aem='/Applications/adobe/AEM/author/crx-quickstart/bin/quickstart'

#On start... Zellij
if [[ -z "$ZELLIJ" ]]; then
  exec zellij
fi

fastfetch

autoload -Uz compinit && compinit
