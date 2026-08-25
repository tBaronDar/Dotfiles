function fish_user_key_bindings
    # Arch's fzf package ships an autoloaded fzf_key_bindings function;
    # Homebrew's fzf instead ships a script that binds the keys when sourced.
    if functions -q fzf_key_bindings
        fzf_key_bindings
    else if set -q HOMEBREW_PREFIX; and test -f "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.fish"
        source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.fish"
    end

    # ctrl+t is owned by zellij (tab mode); move fzf's file search to ctrl+f instead
    bind -e \ct
    bind -M insert -e \ct
    bind \cf fzf-file-widget
    bind -M insert \cf fzf-file-widget
end
