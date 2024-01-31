##########    Prompt(s)    ##########

# Enable colors
autoload -U colors && colors

# Prompt with Vi insert-mode/normal-mode and blinking '$', note blinking '$' only works on some terminals.
terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]
git_branch_test_color() {
    local ref=$(git symbolic-ref --short HEAD 2> /dev/null)
    if [ -n "${ref}" ]; then
        if [ -n "$(git status --porcelain)" ]; then
            local gitstatuscolor='%F{196}'
        else
            local gitstatuscolor='%F{82}'
        fi
        echo "${gitstatuscolor}${ref}"
    else
        echo ""
    fi
}

# Job indicator
jobs_status_indicator() {
    local jobs_output
    declare -p jobs_output >/dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        unset jobs_output
    fi
    jobs_output=$(jobs -s)
    if [[ -n "$jobs_output" ]]; then
        local jobs_count=$(echo "$jobs_output" | wc -l)
        echo "jobs: ${jobs_count}"
    fi
}

remote_indicator() {
    if [[ -n "$SSH_CONNECTION" || -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
        echo 'ssh '
    else
        echo ''
    fi
}

# Version control (git)
autoload -Uz add-zsh-hook vcs_info
zstyle ':vcs_info:*' stagedstr ' +%F{15}staged%f'
zstyle ':vcs_info:*' unstagedstr ' -%F{15}unstaged%f'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' actionformats '%F{5}%F{2}%b%F{3}|%F{1}%a%F{5}%f '
zstyle ':vcs_info:*' formats '%F{208} '$'\uE0A0'' %f$(git_branch_test_color)%f%F{76}%c%F{3}%u%f '
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
zstyle ':vcs_info:*' enable git
+vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        [[ $(git ls-files --other --directory --exclude-standard | sed q | wc -l | tr -d ' ') == 1 ]] ; then
        hook_com[unstaged]+='%F{196} !%f%F{15}untracked%f'
    fi
}

# Prompt
function insert-mode() {
    echo "-- INSERT --"
}

function normal-mode() {
    echo "-- NORMAL --"
}

function my_precmd () {
    vcs_info
    PS1="%{┌─[%F{145}%n%f] %F{39}%0~%f%} ${vcs_info_msg_0_} \$(remote_indicator)\$(jobs_status_indicator)
    %{%{$terminfo_down_sc$(insert-mode)$terminfo[rc]%}%{└─%{["%{$(tput setaf 226)%}""%{$(tput blink)%}"%{$%}"%{$(tput sgr0)%}"%{%G]%}%}%}%}"
}

add-zsh-hook precmd my_precmd

function set-prompt() {
    if [[ ${KEYMAP} == vicmd || ${KEYMAP} == vi-cmd-mode ]]; then
        echo -ne '\e[1 q'
        VI_MODE=$(normal-mode)
    elif [[ ${KEYMAP} == main || ${KEYMAP} == viins || ${KEYMAP} == '' ]]; then
        echo -ne '\e[5 q'
        VI_MODE=$(insert-mode)
    fi
    PS1="%{┌─[%F{145}%n%f] %F{39}%0~%f%} ${vcs_info_msg_0_} \$(remote_indicator)\$(jobs_status_indicator)
    %{%{$terminfo_down_sc$VI_MODE$terminfo[rc]%}%{└─%{["%{$(tput setaf 226)%}""%{$(tput blink)%}"%{$%}"%{$(tput sgr0)%}"%{%G]%}%}%}%}"
}

function update-mode-file() {
    set-prompt
    local current_mode=$(cat ~/.vi-mode)
    local new_mode="$VI_MODE"
    if [[ "$new_mode" != "$current_mode" ]]; then
        echo "$new_mode" >| ~/.vi-mode
    fi
    if command -v tmux &>/dev/null && [[ -n "$TMUX" ]]; then
        tmux refresh-client -S
    fi
}

function check-nvim-running() {
    if pgrep -x "nvim" > /dev/null; then
        VI_MODE=""
        update-mode-file
        if command -v tmux &>/dev/null && [[ -n "$TMUX" ]]; then
            tmux refresh-client -S
        fi
    else
        if [[ ${KEYMAP} == vicmd || ${KEYMAP} == vi-cmd-mode ]]; then
            VI_MODE=$(normal-mode)
        elif [[ ${KEYMAP} == main || ${KEYMAP} == viins || ${KEYMAP} == '' ]]; then
            VI_MODE=$(insert-mode)
        fi
        update-mode-file
        if command -v tmux &>/dev/null && [[ -n "$TMUX" ]]; then
            tmux refresh-client -S
        fi
    fi
}

function zle-line-init() {
    zle reset-prompt
    case "${KEYMAP}" in
        vicmd)
            echo -ne '\e[1 q'
            ;;
        main|viins|*)
            echo -ne '\e[5 q'
            ;;
    esac
}

function zle-keymap-select() {
    update-mode-file
    zle reset-prompt
    case "${KEYMAP}" in
        vicmd)
            echo -ne '\e[1 q'
            ;;
        main|viins|*)
            echo -ne '\e[5 q'
            ;;
    esac
}

preexec () { print -rn -- $terminfo[el]; echo -ne '\e[5 q' ; }

zle -N zle-line-init
zle -N zle-keymap-select

TRAPWINCH() { # Trap the WINCH signal to update the mode file on window size changes
    update-mode-file
}

#function nvim-listener() {
#  local prev_nvim_status="inactive"
#  local nvim_pid=""
#  while true; do
#    local current_nvim_pid=$(pgrep -x "nvim")
#    if [[ -n "$current_nvim_pid" && "$current_nvim_pid" != "$nvim_pid" ]]; then
#      # Neovim started
#      prev_nvim_status="active"
#      nvim_pid="$current_nvim_pid"
#      VI_MODE="" # Clear VI_MODE to show Neovim mode
#      update-mode-file
#      if command -v tmux &>/dev/null && [[ -n "$TMUX" ]]; then
#        tmux refresh-client -S
#      fi
#    elif [[ -z "$current_nvim_pid" && "$prev_nvim_status" == "active" ]]; then
#      # Neovim stopped
#      prev_nvim_status="inactive"
#      nvim_pid=""
#      if [[ ${KEYMAP} == vicmd || ${KEYMAP} == vi-cmd-mode ]]; then
#        VI_MODE=$(normal-mode)
#      elif [[ ${KEYMAP} == main || ${KEYMAP} == viins || ${KEYMAP} == '' ]]; then
#        VI_MODE=$(insert-mode)
#      fi
#      update-mode-file
#      if command -v tmux &>/dev/null && [[ -n "$TMUX" ]]; then
#        tmux refresh-client -S
#      fi
#    fi
#  done
#}

# Start Neovim listener in the background
#nvim-listener &!
set-prompt

RPROMPT='%(?..[%F{196}%?%f] )'
