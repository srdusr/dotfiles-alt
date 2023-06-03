#!/bin/sh

# Show which mode
insert_mode="-- INSERT --"
normal_mode="-- NORMAL --"

if [ -n "$ZSH_VERSION" ]; then
    if [[ $KEYMAP == 'vicmd' ]]; then
        VI_MODE=$normal_mode
    else
        VI_MODE=$insert_mode
    fi
    printf "%s\n" "$VI_MODE"
elif [ -n "$BASH_VERSION" ]; then
    if [[ $BASH_MODE == 'vi' ]]; then
        VI_MODE=$normal_mode
    else
        VI_MODE=$insert_mode
    fi
    printf "%s\n" "$VI_MODE"
else
    echo "Unsupported shell"
fi
