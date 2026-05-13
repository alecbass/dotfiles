#!/usr/bin/env bash

dirs=(
    "ghostty"
    "hypr"
    "zellij"
    "opencode"
)

for dir in "${dirs[@]}"; do
    dotfiles_dir="$HOME/repos/dotfiles/$dir"
    config_dir="$HOME/.config/$dir"

    if [ ! -d "$config_dir" ]; then
        ln -s "$dotfiles_dir" "$config_dir"
    fi
done
