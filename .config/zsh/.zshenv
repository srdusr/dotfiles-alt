# Load local/system wide binaries and scripts
export PATH=$HOME/.bin:$HOME/.local/bin:$HOME/.local/bin/scripts:/usr/local/bin:/sbin:/usr/sbin:$PATH
export PATH="/data/data/com.termux/files/usr/local/bin:$PATH"

# Default Programs:
export EDITOR="nvim"
export VISUAL="nvim"
export READER="zathura"
export TERMINAL="wezterm"
export COLORTERM="truecolor"
export TERM="xterm-256color"
export BROWSER="firefox"
export OPENER="xdg-open"
export MANPAGER="nvim +Man!"
export PAGER="less"
export WM="bspwm"
export XDG_SESSION_TYPE=X11
export FAQ_STYLE='github'

# XDG Paths:
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/X11/.inputrc"
export XINITRC="$HOME/.config/X11/.xinitrc"
export XSERVERRC="$XDG_CONFIG_HOME"/X11/xserverrc
export USERXSESSION="$XDG_CONFIG_HOME/X11/xsession"
export USERXSESSIONRC="$XDG_CONFIG_HOME/X11/xsessionrc"
export ALTUSERXSESSION="$XDG_CONFIG_HOME/X11/Xsession"
export ERRFILE="$XDG_CONFIG_HOME/X11/xsession-errors"
export ICEAUTHORITY="$XDG_CACHE_HOME"/.ICEauthority
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export VIRTUAL_ENV_DISABLE_PROMPT=true
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export HISTFILE="$ZDOTDIR/.zhistory"    # History filepath
export HISTSIZE=1000000                  # Maximum events for internal history
export SAVEHIST=1000000                   # Maximum events in history file
export BANG_HIST                 # Treat the '!' character specially during expansion.
export EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
export INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
export SHARE_HISTORY             # Share history between all sessions.
export HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
export HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
export HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
export HIST_FIND_NO_DUPS         # Do not display a line previously found.
export HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
export HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
export HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
export HIST_VERIFY               # Don't execute immediately upon history expansion.
export HIST_BEEP                 # Beep when accessing nonexistent history.

# Customize `ls` colours
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

# Other XDG paths:
export PATH="/usr/bin/cmake:$PATH"
export WGETRC="$XDG_CONFIG_HOME"/wget/wgetrc
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/ripgreprc"
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export VSCODE_PORTABLE="$XDG_DATA_HOME"/vscode
export PATH=$PATH:/opt/google/chrome

# GnuPG
export GPG_TTY=$(tty)
export GNUPGHOME="$HOME/.config/gnupg"

# Kubernetes
# kubernetes aliases
if which kubectl > /dev/null; then
  function replaceNS() { kubectl config view --minify --flatten --context=$(kubectl config current-context) | yq ".contexts[0].context.namespace=\"$1\"" }
  alias kks='KUBECONFIG=<(replaceNS "kube-system") kubectl'
  alias kam='KUBECONFIG=<(replaceNS "authzed-monitoring") kubectl'
  alias kas='KUBECONFIG=<(replaceNS "authzed-system") kubectl'
  alias kar='KUBECONFIG=<(replaceNS "authzed-region") kubectl'
  alias kt='KUBECONFIG=<(replaceNS "tenant") kubectl'
  which kubectl-krew > /dev/null && path=($HOME/.krew/bin $path)
  function rmfinalizers() {
    kubectl get deployment $1 -o json | jq '.metadata.finalizers = null' | k apply -f -
  }
fi

# Android SDK
export ANDROID_HOME=/opt/android-sdk
export PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/tools/bin:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/emulator:$PATH
export ANDROID_SDK_ROOT=/opt/android-sdk
export PATH=$ANDROID_SDK_ROOT:$PATH
#export PATH=$PATH:$ANDROID_HOME/emulator
#export PATH=$PATH:$ANDROID_HOME/platform-tools/
#export PATH=$PATH:$ANDROID_HOME/tools/bin/
#export PATH=$PATH:$ANDROID_HOME/tools/
#PATH=$ANDROID_HOME/emulator:$PATH
#export ANDROID_SDK_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/android"

# Programming Environment Variables:

# Rust
export RUSTUP_HOME=${XDG_DATA_HOME:-$HOME/.local/share}/rustup
export CARGO_HOME=${XDG_DATA_HOME:-$HOME/.local/share}/cargo
[[ -d $CARGO_HOME/bin ]] && path=($CARGO_HOME/bin $path)
if which rustc > /dev/null; then export RUST_BACKTRACE=1; fi
#export PATH="$HOME/.cargo/bin:$PATH"
#export CARGO_HOME=${XDG_DATA_HOME}/cargo
#export RUSTUP_HOME=${XDG_DATA_HOME}/rustup
#export PATH="${CARGO_HOME}/bin:${RUSTUP_HOME}/bin:$PATH"


# Java
export JAVA_HOME='/usr/lib/jvm/java-8-openjdk'
export PATH=$JAVA_HOME/bin:$PATH


# Flutter
export PATH="$PATH:/opt/flutter/bin"


# Go
export GO_PATH=${XDG_DATA_HOME}/go


# Javascript
# global node installs (gross)
[[ -d "$XDG_DATA_HOME/node/bin" ]] && path=($XDG_DATA_HOME/node/bin $path)
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc

nvm() {
    local green_color
    green_color=$(tput setaf 2)
    local reset_color
    reset_color=$(tput sgr0)
    echo -e "${green_color}nvm${reset_color} $@"
}

if [ -s "$NVM_DIR/nvm.sh" ]; then
    nvm_cmds=(nvm node npm yarn)
    for cmd in "${nvm_cmds[@]}"; do
        alias "$cmd"="unalias ${nvm_cmds[*]} && unset nvm_cmds && . $NVM_DIR/nvm.sh && $cmd"
    done
fi

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


# Ruby
export GEM_PATH="$XDG_DATA_HOME/ruby/gems"
export GEM_SPEC_CACHE="$XDG_DATA_HOME/ruby/specs"
export GEM_HOME="$XDG_DATA_HOME/ruby/gems"
#if [[ -d ~/.gem/ruby ]]; then
#	ver=$(find ~/.gem/ruby/* -maxdepth 0 | sort -rV | head -n 1)
#	export PATH="$PATH:${ver}/bin"
#fi


# Python
# lazy load pyenv
export PYENV_ROOT=${PYENV_ROOT:-$HOME/.pyenv}
[[ -a $PYENV_ROOT/bin/pyenv ]] && path=($PYENV_ROOT/bin $path)
if type pyenv &> /dev/null || [[ -a $PYENV_ROOT/bin/pyenv ]]; then
  function pyenv() {
    unset pyenv
    path=($PYENV_ROOT/shims $path)
    eval "$(command pyenv init -)"
    if which pyenv-virtualenv-init > /dev/null; then
      eval "$(pyenv virtualenv-init -)"
      export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    fi
    pyenv $@
  }
fi
export WORKON_HOME="$XDG_DATA_HOME"/virtualenvs


# PHP
PATH="$HOME/.config/composer/vendor/bin:$PATH"


# Lua



export ASPROOT="${XDG_CACHE_HOME:-$HOME/.cache}/asp"
# fixing paths
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export IPYTHONDIR="$XDG_CONFIG_HOME"/jupyter, export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter





# Program settings
#export MOZ_USE_XINPUT2="1"		# Mozilla smooth scrolling/touchpads.

# Scaling
#export QT_AUTO_SCREEN_SCALE_FACTOR=0
#export QT_SCALE_FACTOR=1
#export QT_SCREEN_SCALE_FACTORS="1;1;1"
#export GDK_SCALE=1
#export GDK_DPI_SCALE=1

export VIDEO="vlc"
#export IMAGE="sxiv"

#xbindkeys -f "$XDG_CONFIG_HOME"/xbindkeys/config

#typeset -U PATH path
export GTK_IM_MODULE='fcitx'
export QT_IM_MODULE='fcitx'
export SDL_IM_MODULE='fcitx'
export XMODIFIERS='@im=fcitx'


# Start blinking
#export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
# Start bold
#export LESS_TERMCAP_md=$(tput bold; tput setaf 2) # green
# Start stand out
#export LESS_TERMCAP_so=$(tput bold; tput setaf 3) # yellow
# End standout
#export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
# Start underline
#export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 1) # red
# End Underline
#export LESS_TERMCAP_ue=$(tput sgr0)
# End bold, blinking, standout, underline
#export LESS_TERMCAP_me=$(tput sgr0).
