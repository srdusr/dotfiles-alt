#!/usr/bin/bash

#USAGE="USAGE: $0 OPTION_NAME ON_STATE OFF_STATE"

#OPTION_NAME=$1
#ON_STATE=$2
#OFF_STATE=$3
#
#if [[ "$#" != 3 ]]; then
#  echo $USAGE
#  exit 1
#fi
#
#if [[ `tmux show-option -w | grep "$OPTION_NAME $ON_STATE"` ]]; then
#  OPTION_VALUE=$OFF_STATE
#else
#  OPTION_VALUE=$ON_STATE
#fi
#
#tmux display-message "monitor activity: $OPTION_NAME $OPTION_VALUE"
#tmux set-option -w $OPTION_NAME $OPTION_VALUE > /dev/null


#if
#  [[ `tmux set -ag status-right "#[fg=#50fa7b,bg=default] #{?client_prefix,#[reverse] Prefix #[noreverse] ,} #[bg=default,fg=#50fa7b]#[bg=#50fa7b,fg=black]#( ~/.config/tmux/right-status.sh ) %H:%M | %d-%b-%y " == true` ]]
#then 
#  tmux set -u status-right && tmux set -g status-right "#[fg=#50fa7b,bg=default] #{?client_prefix,#[reverse] Prefix #[noreverse] ,} #[bg=default,fg=#50fa7b]#[bg=#50fa7b,fg=black] %H:%M | %d-%b-%y ";
#elif
#  [[ `tmux set -g status-right "#[fg=#50fa7b,bg=default] #{?client_prefix,#[reverse] Prefix #[noreverse] ,} #[bg=default,fg=#50fa7b]#[bg=#50fa7b,fg=black] %H:%M | %d-%b-%y " == true` ]]
#then
#  tmux set -u status-right && tmux set -g status-right "#[fg=#50fa7b,bg=default] #{?client_prefix,#[reverse] Prefix #[noreverse] ,} #[bg=default,fg=#50fa7b]#[bg=#50fa7b,fg=black]#( ~/.config/tmux/right-status.sh ) %H:%M | %d-%b-%y ";
#else
#  tmux set -u status-right && tmux set -g status-right "#[fg=#50fa7b,bg=default] #{?client_prefix,#[reverse] Prefix #[noreverse] ,} #[bg=default,fg=#50fa7b]#[bg=#50fa7b,fg=black] %H:%M | %d-%b-%y "
#fi


#if
#  [[ `tmux set -g status-right "#[fg=#50fa7b,bg=default] #{?client_prefix,#[reverse] Prefix #[noreverse] ,} #[bg=default,fg=#50fa7b]#[bg=#50fa7b,fg=black]#( ~/.config/tmux/right-status.sh ) %H:%M | %d-%b-%y " == true` ]];
#then 
#  tmux set -u status-right && tmux set -g status-right "#[fg=#50fa7b,bg=default] #{?client_prefix,#[reverse] Prefix #[noreverse] ,} #[bg=default,fg=#50fa7b]#[bg=#50fa7b,fg=black]#( ~/.config/tmux/right-status.sh ) %H:%M | %d-%b-%y "
#elif
#  [[ `tmux set -u status-right && tmux set -g status-right "#[fg=#50fa7b,bg=default] #{?client_prefix,#[reverse] Prefix #[noreverse] ,} #[bg=default,fg=#50fa7b]#[bg=#50fa7b,fg=black] %H:%M | %d-%b-%y " == true` ]];
#then
#  tmux set -u status-right && tmux set -g status-right "#[fg=#50fa7b,bg=default] #{?client_prefix,#[reverse] Prefix #[noreverse] ,} #[bg=default,fg=#50fa7b]#[bg=#50fa7b,fg=black] %H:%M | %d-%b-%y "
#fi
if [[ `tmux set -g status-left "#[bg=#50fa7b,fg=black] ❐ #S #( ~/.config/tmux/left-status.sh ) #[fg=#50fa7b,bg=default]" == true` ]]; then 
  tmux set -g status-left "#[bg=#50fa7b,fg=black] ❐ #S #[fg=#50fa7b,bg=default]"
elif 
  [[ `tmux set -g status-left "#[bg=#50fa7b,fg=black] ❐ #S #[fg=#50fa7b,bg=default]" == true` ]]; then 
  tmux set -g status-left "#[bg=#50fa7b,fg=black] ❐ #S #( ~/.config/tmux/left-status.sh ) #[fg=#50fa7b,bg=default]"
else 
  tmux set -g status-left "#[bg=#50fa7b,fg=black] ❐ #S #[fg=#50fa7b,bg=default]" &
fi


