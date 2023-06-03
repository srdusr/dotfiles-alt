#!/bin/bash

# Set vi-mode and key bindings for zsh
if [[ -n "$ZSH_VERSION" ]]; then
    bindkey -v
    export KEYTIMEOUT=1

    # Show which mode
    terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]

    function insert-mode () { echo "-- INSERT --" }
    function normal-mode () { echo "-- NORMAL --" }

    precmd () {
        # yes, I actually like to have a new line, then some stuff and then 
        # the input line
        print -rP "
    [%D{%a, %d %b %Y, %H:%M:%S}] %n %{$fg[blue]%}%m%{$reset_color%}"

        # this is required for initial prompt and a problem I had with Ctrl+C or
        # Enter when in normal mode (a new line would come up in insert mode,
        # but normal mode would be indicated)
        PS1="%{$terminfo_down_sc$(insert-mode)$terminfo[rc]%}%~ $ "
    }
    function set-prompt () {
        case ${KEYMAP} in
          (vicmd)      VI_MODE="$(normal-mode)" ;;
          (main|viins) VI_MODE="$(insert-mode)" ;;
          (*)          VI_MODE="$(insert-mode)" ;;
        esac
        PS1="%{$terminfo_down_sc$VI_MODE$terminfo[rc]%}%~ $ "
    }

    function zle-line-init () {
        set-prompt
        zle reset-prompt
        zle-keymap-select
    }
    preexec () { print -rn -- $terminfo[el]; }

    zle -N zle-line-init
    zle -N zle-keymap-select

    # Fix backspace bug when switching modes
    bindkey '^?' backward-delete-char

    # Edit line in vim with alt-e
    autoload edit-command-line; zle -N edit-command-line
    bindkey '^e' edit-command-line

    # Navigate in complete menu
    bindkey -M menuselect 'h' vi-backward-char
    bindkey -M menuselect 'j' vi-down-line-or-history
    bindkey -M menuselect 'k' vi-up-line-or-history
    bindkey -M menuselect 'l' vi-forward-char

    # Map 'jk' to Escape key in INSERT mode
    bindkey -M viins 'jk' vi-cmd-mode

# Set vi-mode and key bindings for bash
elif [[ -n "$BASH_VERSION" ]]; then
    set -o vi

    # Show which mode
    show-mode() {
      if [[ "$BASH_MODE" == "vi" ]]; then
        echo -ne "\[\033[1m\]-- NORMAL --\[\033[0m\]\n"
      else
        echo -ne "\[\033[1m\]-- INSERT --\[\033[0m\]\n"
      fi
    }
    PS1='$(show-mode)\u@\h:\w\$ '

    # Edit line in vim with alt-e
    edit-command-line() {
      local temp=$(mktemp /tmp/bash-edit-line.XXXXXXXXXX)
      history -a
      history -n
      fc -ln -1 > "${temp}"
      vim "${temp}"
      READLINE_LINE=$(cat "${temp}")
      READLINE_POINT=0
      rm -f "${temp}"
    }
    bind -x '"\ee": edit-command-line'

    # Navigate in complete menu
    bind -m vi-command '"h": backward-char'    # map h to backward-char
    bind -m vi-command '"j": down-line-or-history'  # map j to down-line-or-history
    bind -m vi-command '"k": up-line-or-history'    # map k to up-line-or-history
    bind -m vi-command '"l": forward-char'    # map l to forward-char

    # Map 'jk' to Escape key in INSERT mode
    bind -m vi-insert '"jk":vi-movement-mode'

    # Fix backspace bug when switching modes
    stty erase '^?'
fi

# Reload .bashrc or .bash_profile file if using bash
if [[ -n "$BASH_VERSION" ]]; then
    if [[ -f "$HOME/.bashrc" ]]; then
        source ~/.bashrc
    elif [[ -f "$HOME/.bash_profile" ]]; then
        source ~/.bash_profile
    fi
fi

# Reload .zshrc file if using zsh
if [[ -n "$ZSH_VERSION" ]]; then
    source ~/.zshrc
fi
