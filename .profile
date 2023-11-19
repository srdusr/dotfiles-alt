#!/bin/sh

[[ -f ~/.config/zsh/.zshenv ]] && source ~/.config/zsh/.zshenv

#export DISPLAY=:0
export DISPLAY=:$(echo $XDG_VTNR)
