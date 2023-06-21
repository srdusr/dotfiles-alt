
#  ███████╗███████╗██╗  ██╗██████╗  ██████╗
#  ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#    ███╔╝ ███████╗███████║██████╔╝██║
#   ███╔╝  ╚════██║██╔══██║██╔══██╗██║
#  ███████╗███████║██║  ██║██║  ██║╚██████╗
#  ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH=$HOME/bin:/usr/local/bin:/sbin:/usr/sbin:$PATH

##########    Vi mode    ##########
bindkey -v

#export KEYTIMEOUT=1
export KEYTIMEOUT=25
export EDITOR=$VISUAL
export VISUAL=nvim
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^[[3~'  delete-char
bindkey -M vicmd '^[[3~'  delete-char
bindkey -v '^?' backward-delete-char
bindkey -r '\e/'
bindkey -s jk '\e'
bindkey "^W" backward-kill-word
bindkey "^H" backward-delete-char      # Control-h also deletes the previous char
bindkey "^U" backward-kill-line

bindkey "^[j" history-search-forward # or you can bind it to the down key "^[[B"
bindkey "^[k" history-search-backward # or you can bind it to Up key "^[[A"
bindkey '^X' autosuggest-execute
bindkey '^Y' autosuggest-accept

# Edit line in vim with alt-e
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey '^[e' edit-command-line # alt + e

# Allow CTRL+D to exit zsh with partial command line (non empty line)
exit_zsh() { exit }
zle -N exit_zsh
bindkey '^D' exit_zsh

# Auto-completion
#autoload -U promptinit && promptinit
autoload -Uz compinit && compinit

# Accept completion with <tab> or Ctrl+i and go to next/previous suggestions with Vi like keys: Ctrl+n/p
zmodload -i zsh/complist
accept-and-complete-next-history() {
    zle expand-or-complete-prefix
}

zle -N accept-and-complete-next-history
bindkey -M menuselect '^i' accept-and-complete-next-history
bindkey '^n' expand-or-complete
bindkey '^p' reverse-menu-complete
zstyle ':completion:*' menu select=1

# Some other useful functionalities
setopt autocd		# Automatically cd into typed directory.
stty intr '^q'        # free Ctrl+C for copy use Ctrl+q instead
stty lnext '^-'        # free Ctrl+V for paste use ^- instead
stty stop undef		# Disable ctrl-s to freeze terminal.
stty start undef

export PATH="$HOME/.local/bin:$PATH"
export VIRTUAL_ENV_DISABLE_PROMPT=true
#unsetopt BEEP

# Enable various options
setopt interactive_comments beep extendedglob nomatch notify completeinword prompt_subst

##########    Prompt(s)    ##########

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors

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

# Version control (git)
autoload -Uz add-zsh-hook vcs_info
zstyle ':vcs_info:*' stagedstr ' +%F{15}staged%f' 
zstyle ':vcs_info:*' unstagedstr ' -%F{15}unstaged%f' 
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' actionformats '%F{5}%F{2}%b%F{3}|%F{1}%a%F{5}%f '
zstyle ':vcs_info:*' formats \
  '%F{208} '$'\uE0A0'' %f$(git_branch_test_color)%f%F{76}%c%F{3}%u%f '
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
    PS1="%{┌─[%F{145}%n%f] %F{39}%0~%f%} ${vcs_info_msg_0_} \$(jobs_status_indicator)
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
    PS1="%{┌─[%F{145}%n%f] %F{39}%0~%f%} ${vcs_info_msg_0_} \$(jobs_status_indicator)
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

zle -N zle-keymap-select
zle -N zle-line-init

TRAPWINCH() { # Trap the WINCH signal to update the mode file on window size changes
  update-mode-file
}

function nvim-listener() {
  local prev_nvim_status="inactive"
  local nvim_pid=""

  while true; do
    local current_nvim_pid=$(pgrep -x "nvim")

    if [[ -n "$current_nvim_pid" && "$current_nvim_pid" != "$nvim_pid" ]]; then
      # Neovim started
      prev_nvim_status="active"
      nvim_pid="$current_nvim_pid"
      VI_MODE="" # Clear VI_MODE to show Neovim mode
      update-mode-file
      if command -v tmux &>/dev/null && [[ -n "$TMUX" ]]; then
        tmux refresh-client -S
      fi
    elif [[ -z "$current_nvim_pid" && "$prev_nvim_status" == "active" ]]; then
      # Neovim stopped
      prev_nvim_status="inactive"
      nvim_pid=""
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
    # Add a delay
    # sleep 0.5
  done
}

# Start Neovim listener in the background
nvim-listener &!
set-prompt

RPROMPT='%(?..[%F{196}%?%f] )'


##########    Useful Commands/Alias    ##########

alias s="systemctl"
alias j="journalctl xe"

# Enter directory and list contents
cd() {
	if [ -n "$1" ]; then
		builtin cd "$@" && ls -pvA --color=auto --group-directories-first
	else
		builtin cd ~ && ls -pvA --color=auto --group-directories-first
	fi
}

# Back up a file. Usage "backupthis <filename>"
backupthis() {
	cp -riv $1 ${1}-$(date +%Y%m%d%H%M).backup;
}

# Let FZF use ripgrep by default
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi
# Setup fzf
# ---------
if [[ ! "$PATH" == */root/.local/share/nvim/plugged/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/root/.local/share/nvim/plugged/fzf/bin"
fi

# Spawn a clone of current terminal 
putstate () {
    declare +x >~/environment.tmp
    declare -x >>~/environment.tmp
    echo cd "$PWD" >>~/environment.tmp
}

getstate () {
    . ~/environment.tmp
}

# use ctrl-z to toggle in and out of bg
function toggle_fg_bg() {
    if [[ $#BUFFER -eq 0 ]]; then
        BUFFER="fg"
        zle accept-line
    else
        BUFFER=""
        zle clear-screen
    fi
}
zle -N toggle_fg_bg
bindkey '^Z' toggle_fg_bg

# cd using "up n" as a command up as many directories, example "up 3"
up() {
    # default parameter to 1 if non provided
    declare -i d=${@:-1}
    # ensure given parameter is non-negative. Print error and return if it is
    (( $d < 0 )) && (>&2 echo "up: Error: negative value provided") && return 1;
    # remove last d directories from pwd, append "/" in case result is empty
    cd "$(pwd | sed -E 's;(/[^/]*){0,'$d'}$;;')/";
}

# More history for cd and use "cd -TAB"
setopt AUTO_PUSHD                  # pushes the old directory onto the stack
zstyle ':completion:*:directory-stack' list-colors '=(#b) #([0-9]#)*( *)==95=38;5;12'

# List upto last 10 visited directories using "d" and quickly cd into any specific one
# using just a number from "0" to "9"
alias d="dirs -v | head -10" 
alias 0="cd +0"
alias 1="cd +1"
alias 2="cd +2"
alias 3="cd +3"
alias 4="cd +4"
alias 5="cd +5"
alias 6="cd +6"
alias 7="cd +7"
alias 8="cd +8"
alias 9="cd +9"

# Allow nnn filemanager to cd on quit
nnn() {
  declare -x +g NNN_TMPFILE=$(mktemp --tmpdir $0.XXXX)
  trap "rm -f $NNN_TMPFILE" EXIT
  =nnn $@
  [ -s $NNN_TMPFILE ] && source $NNN_TMPFILE
}

# Extract with one command
extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1        ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1       ;;
             *.rar)       rar x $1     ;;
             *.gz)        gunzip $1     ;;
             *.tar)       tar xf $1        ;;
             *.tbz2)      tar xjf $1      ;;
             *.tgz)       tar xzf $1       ;;
             *.zip)       unzip $1     ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

### Dotfiles
alias config='git --git-dir=$HOME/.cfg --work-tree=$HOME'

# Set bare dotfiles repository git environment variables dynamically
function set_git_env_vars() {
  # Check if the current command is a package manager command
  if [[ "${(%)${(z)history[1]}}" =~ ^(pacman|yay|apt|dnf|brew|npm|pip|gem|go|cargo) ]]; then
    return
  fi
  local git_dir="$(git rev-parse --git-dir -C . 2>/dev/null)"
  if [[ -n "$git_dir" ]]; then
    local is_bare="$(git -C "$git_dir" rev-parse --is-bare-repository 2>/dev/null)"
    if [[ "$is_bare" == "true" ]]; then
      export GIT_DIR="$HOME/.cfg"
      export GIT_WORK_TREE=$(realpath $(eval echo ~))
    else
      unset GIT_DIR
      unset GIT_WORK_TREE
    fi
  else
    local root_dir="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [[ -n "$root_dir" ]]; then
      unset GIT_DIR
      export GIT_WORK_TREE="$root_dir"
    else
      export GIT_DIR="$HOME/.cfg"
      export GIT_WORK_TREE=$(realpath $(eval echo ~))
    fi
  fi
}

# Define an auto_cd hook to automatically update Git environment variables
function chpwd() {
  set_git_env_vars
}
# Call the function to set Git environment variables when the shell starts up
set_git_env_vars

function gsp
{
    # Config file for subtrees
    #
    # Format:
    # <prefix>;<remote address>;<remote branch>
    # # Lines starting with '#' will be ignored
    GIT_SUBTREE_FILE="$PWD/.gitsubtrees"

    if [ ! -f $GIT_SUBTREE_FILE ]; then
        echo "Nothing to do - file <`basename $GIT_SUBTREE_FILE`> does not exist."
        return
    fi

    OLD_IFS=$IFS
    IFS=$'\n'
    for LINE in $(cat $GIT_SUBTREE_FILE); do

        # Skip lines starting with '#'.
        if [[ $LINE = \#* ]]; then
            continue
        fi

        # Parse the current line.
        PREFIX=`echo $LINE | cut -d';' -f 1`
        REMOTE=`echo $LINE | cut -d';' -f 2`
        BRANCH=`echo $LINE | cut -d';' -f 3`

        # Push to the remote.
        echo "config subtree pull --prefix=$PREFIX $REMOTE $BRANCH"
        config subtree pull --prefix=$PREFIX $REMOTE $BRANCH
    done
}

alias vi='nvim'
alias nv='nvim'
alias trash_restore='gio trash --restore "$(gio trash --list | fzf | cut -f 1)"'
alias ec='$EDITOR $HOME/.config/zsh/.zshrc'
alias sc="source $HOME/.config/zsh/.zshrc"
alias keyname="xev | sed -n 's/[ ]*state.* \([^ ]*\)).*/\1/p'"

# Print previous command into a file
getlast () {
    fc -nl $((HISTCMD - 1))
}

alias pp='getlast 2>&1 |&tee -a output.txt'

# Print output of a command NOTE: Must be used in conjunction but no need for "|" symbol
alias -g cap='2>&1 | tee -a output.txt'

# confirmation #
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias rm='rm -i'

# Suspend(sleep)/hibernate and lock screen if using systemctl
alias suspend='systemctl suspend && betterlockscreen --lock dimblur'
alias hibernate='systemctl hibernate'

# Tmux layout
openSession () {
    tmux split-window -h -t
    tmux split-window -v -t
    tmux resize-pane -U 5 
}

##########    Source Plugins, should be last    ##########

# Load zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# Load fzf keybindings and completion
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
source /usr/share/fzf-marks/fzf-marks.plugin.zsh 2>/dev/null

# Suggest aliases for commands
source /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh 2>/dev/null

# Load fish like auto suggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
