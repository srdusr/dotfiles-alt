#!/bin/sh

#[[ -f ~/.config/zsh/.zshenv ]] && source ~/.config/zsh/.zshenv
#[[ -f ~/.config/zsh/.zshrc ]] && source ~/.config/zsh/.zshrc

# Xresources
[[ -f ~/.config/X11/.Xresources ]] && xrdb -merge ~/.config/X11/.Xresources
#. "/home/srdusr/.local/share/cargo/env"
#. "$HOME/.cargo/env"
ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
