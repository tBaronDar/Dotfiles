function fish_user_key_bindings
    if functions -q fzf_key_bindings
        # Arch's fzf package ships this as an autoloaded function
        fzf_key_bindings
    else if type -q fzf
        # fzf >= 0.48 can emit its own fish integration directly, regardless
        # of how/where it was installed (Homebrew, binary, etc.)
        fzf --fish | source
    end

    # ctrl+t is owned by zellij (tab mode); move fzf's file search to ctrl+f instead
    if functions -q fzf-file-widget
        bind -e \ct
        bind -M insert -e \ct
        bind \cf fzf-file-widget
        bind -M insert \cf fzf-file-widget
    end
end
