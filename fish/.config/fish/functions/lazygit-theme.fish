function lazygit-theme --description 'Pick a lazygit theme with fzf'
    set -l config_dir "$HOME/.config/lazygit"
    set -l themes_dir "$config_dir/themes"

    set -l choice (find -L "$themes_dir" -maxdepth 1 -name '*.yml' -printf '%f\n' \
        | string replace -r '\.yml$' '' \
        | sort \
        | fzf --prompt='lazygit theme> ' --preview="bat --style=numbers --color=always $themes_dir/{}.yml")

    if test -z "$choice"
        return 1
    end

    echo "$choice" >"$config_dir/current_theme"
    echo "Switched lazygit theme to $choice"
end
