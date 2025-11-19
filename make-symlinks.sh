#!/usr/bin/env bash

dirs=(
    "ghostty"
    "hypr"
    "zellij"
)

for dir in "${dirs[@]}"; do
    dotfiles_dir="$HOME/Documents/dotfiles/$dir"
    config_dir="$HOME/.config/$dir"

    if [ ! -d "$config_dir" ]; then
        "$HOME/Documents/dotfiles/ghostty"
        ln -s "$dotfiles_dir" "$config_dir"
    fi
done

# ln -s "$HOME/Documents/dotfiles/ghostty" "$HOME/.config/ghostty"
# ln -s "$HOME/Documents/dotfiles/hypr" "$HOME/.config/hypr"
# ln -s "$HOME/Documents/dotfiles/zellij" "$HOME/.config/zellij"
