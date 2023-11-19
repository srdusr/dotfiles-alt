#!/bin/sh

[[ -f ~/.config/zsh/.zshenv ]] && source ~/.config/zsh/.zshenv

if [ "$XDG_SESSION_TYPE" = "x11" ]; then
    export DISPLAY=:0
fi
