function fish_user_key_bindings
    fzf_key_bindings

    # ctrl+t is owned by zellij (tab mode); move fzf's file search to ctrl+f instead
    bind -e \ct
    bind -M insert -e \ct
    bind \cf fzf-file-widget
    bind -M insert \cf fzf-file-widget
end
