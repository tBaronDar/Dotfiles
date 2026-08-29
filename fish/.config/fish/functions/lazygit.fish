function lazygit --wraps lazygit --description 'Launch lazygit with the theme picked via lazygit-theme'
    set -l config_dir "$HOME/.config/lazygit"
    set -l configs "$config_dir/config.yml"
    set -l theme_file "$config_dir/current_theme"

    if test -f "$theme_file"
        set -l theme (cat "$theme_file")
        set -l theme_path "$config_dir/themes/$theme.yml"
        if test -f "$theme_path"
            set -a configs "$theme_path"
        end
    end

    LG_CONFIG_FILE=(string join , $configs) command lazygit $argv
end
