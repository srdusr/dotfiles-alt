##########    Aliases    ##########

### Dotfiles
alias config='git --git-dir=$HOME/.cfg --work-tree=$HOME'
cfg_files=$(config ls-tree --name-only -r HEAD)

export CFG_FILES="$cfg_files"

# Define alias for nvim/vim (fallback to vim)
if command -v nvim > /dev/null; then
    alias vi='nvim'
else
    alias vi='vim'
fi

# Confirmation #
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias rm='rm -i'

alias ls='ls --color=auto --group-directories-first'
alias lsd="lsd --group-directories-first"
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'

# List upto last 10 visited directories using "d" and quickly cd into any specific one
alias d="dirs -v | head -10"

# Using just a number from "0" to "9"
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

alias sc="systemctl"
alias jc="journalctl xe"
#alias suspend='systemctl suspend && betterlockscreen -l' # Suspend(sleep) and lock screen if using systemctl
alias suspend='systemctl suspend' # Suspend(sleep) and lock screen if using systemctl
alias hibernate='systemctl hibernate' # Hibernate
alias lock='DISPLAY=:0 xautolock -locknow' # Lock my workstation screen from my phone
alias oports="sudo lsof -i -P -n | grep -i 'listen'" # List open ports
alias trash_restore='gio trash --restore "$(gio trash --list | fzf | cut -f 1)"'
alias keyname="xev | sed -n 's/[ ]*state.* \([^ ]*\)).*/\1/p'"
alias wget=wget --hsts-file="$XDG_CACHE_HOME/wget-hsts" # wget does not support environment variables
alias pp='getlast 2>&1 |&tee -a output.txt'
alias lg='la | grep'
alias pg='ps aux | grep'
alias py='python'
alias py3='python3'
alias sha256='shasum -a 256'
alias rgf='rg -F'

# Time aliases
alias ber='TZ=Europe/Berlin date'
alias nyc='TZ=America/New_York date'
alias sfo='TZ=America/Los_Angeles date'
alias utc='TZ=Etc/UTC date'

alias src='source ~/.zshrc'
alias p=proxy

# Alias for android-studio
alias android-studio='/opt/android-studio/bin/studio.sh'
