
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


function gsp() {
    # Config file for subtrees
    #
    # Format:
    # <prefix>;<remote address>;<remote branch>
    # # Lines starting with '#' will be ignored
    GIT_SUBTREE_FILE="$PWD/.gitsubtrees"

    if [ ! -f "$GIT_SUBTREE_FILE" ]; then
        echo "Nothing to do - file <$GIT_SUBTREE_FILE> does not exist."
        return
    fi

    if ! command -v config &> /dev/null; then
        echo "Error: 'config' command not found. Make sure it's available in your PATH."
        return
    fi

    OLD_IFS=$IFS
    IFS=$'\n'
    for LINE in $(cat "$GIT_SUBTREE_FILE"); do

        # Skip lines starting with '#'.
        if [[ $LINE = \#* ]]; then
            continue
        fi

        # Parse the current line.
        PREFIX=$(echo "$LINE" | cut -d';' -f 1)
        REMOTE=$(echo "$LINE" | cut -d';' -f 2)
        BRANCH=$(echo "$LINE" | cut -d';' -f 3)

        # Pull from the remote.
        echo "Executing: git subtree pull --prefix=$PREFIX $REMOTE $BRANCH"
        if git subtree pull --prefix="$PREFIX" "$REMOTE" "$BRANCH"; then
            echo "Subtree pull successful for $PREFIX."
        else
            echo "Error: Subtree pull failed for $PREFIX."
        fi
    done

    IFS=$OLD_IFS
}

# Print previous command into a file
getlast () {
    fc -nl $((HISTCMD - 1))
}

# Enter directory and list contents
cd() {
    if [ -n "$1" ]; then
        builtin cd "$@" && ls -pvA --color=auto --group-directories-first
    else
        builtin cd ~ && ls -pvA --color=auto --group-directories-first
    fi
}

# cd using "up n" as a command up as many directories, example "up 3"
up() {
    # default parameter to 1 if non provided
    declare -i d=${@:-1}
    # ensure given parameter is non-negative. Print error and return if it is
    (( $d < 0 )) && (>&2 echo "up: Error: negative value provided") && return 1;
    # remove last d directories from pwd, append "/" in case result is empty
    cd "$(pwd | sed -E 's;(/[^/]*){0,'$d'}$;;')/";
}

# cd into $XDG_CONFIG_HOME/$1 directory
c() {
    local root=${XDG_CONFIG_HOME:-~/.config}
    local dname="$root/$1"
    if [[ ! -d "$dname" ]]; then
        return
    fi
    cd "$dname"
}

# Make and cd into directory and any parent directories
mkcd () {
    if [[ -z "$1" ]]; then
        echo "Usage: mkcd <dir>" 1>&2
        return 1
    fi
    mkdir -p "$1"
    cd "$1"
}
back() {
    for file in "$@"; do
        cp "$file" "$file".bak
    done
}
reposize() {
    url=`echo $1 \
        | perl -pe 's#(?:https?://github.com/)([\w\d.-]+\/[\w\d.-]+).*#\1#g' \
        | perl -pe 's#git\@github.com:([\w\d.-]+\/[\w\d.-]+)\.git#\1#g'
    `
    printf "https://github.com/$url => "
    curl -s https://api.github.com/repos/$url \
        | jq '.size' \
        | numfmt --to=iec --from-unit=1024
}

# Launch a program in a terminal without getting any output,
# and detache the process from terminal
# (can then close the terminal without terminating process)
-echo() {
    "$@" &> /dev/null & disown
}
#pom() {
#    local -r HOURS=${1:?}
#    local -r MINUTES=${2:-0}
#    local -r POMODORO_DURATION=${3:-25}
#
#    bc <<< "(($HOURS * 60) + $MINUTES) / $POMODORO_DURATION"
#}

#mnt() {
#    local FILE="/mnt/external"
#    if [ ! -z $2 ]; then
#        FILE=$2
#    fi
#
#    if [ ! -z $1 ]; then
#        sudo mount "$1" "$FILE" -o rw
#        echo "Device in read/write mounted in $FILE"
#    fi
#
#    if [ $# = 0 ]; then
#        echo "You need to provide the device (/dev/sd*) - use lsblk"
#    fi
#}
#
#umnt() {
#    local DIRECTORY="/mnt"
#    if [ ! -z $1 ]; then
#        DIRECTORY=$1
#    fi
#    MOUNTED=$(grep $DIRECTORY /proc/mounts | cut -f2 -d" " | sort -r)
#    cd "/mnt"
#    sudo umount $MOUNTED
#    echo "$MOUNTED unmounted"
#}

mntmtp() {
    local DIRECTORY="$HOME/mnt"
    if [ ! -z $2 ]; then
        local DIRECTORY=$2
    fi
    if [ ! -d $DIRECTORY ]; then
        mkdir $DIRECTORY
    fi

    if [ ! -z $1 ]; then
        simple-mtpfs --device "$1" "$DIRECTORY"
        echo "MTPFS device in read/write mounted in $DIRECTORY"
    fi

    if [ $# = 0 ]; then
        echo "You need to provide the device number - use simple-mtpfs -l"
    fi
}

umntmtp() {
    local DIRECTORY="$HOME/mnt"
    if ; then
        DIRECTORY=$1
    fi
    cd $HOME
    umount $DIRECTORY
    echo "$DIRECTORY with mtp filesystem unmounted"
}
duckduckgo() {
    lynx -vikeys -accept_all_cookies "https://lite.duckduckgo.com/lite/?q=$@"
}

wikipedia() {
    lynx -vikeys -accept_all_cookies "https://en.wikipedia.org/wiki?search=$@"
}
function filesize() {
    # Check if 'du' supports the -b option, which provides sizes in bytes.
    if du -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh;  # If supported, use -sbh options for 'du'.
    else
        local arg=-sh;   # If not supported, use -sh options for 'du'.
    fi

    # Check if no arguments are provided.
    if [ "$#" -eq 0 ]; then
        # Calculate and display sizes for all files and directories in cwd.
        du $arg ./*
    else
        # Calculate and display sizes for the specified files and directories.
        du $arg -- "$@"
    fi
}

fgl() {
    git log --graph --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
        --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

fgb() {
  local branches branch
  branches=$(git --no-pager branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# +--------+
# | Pacman |
# +--------+

# TODO can improve that with a bind to switch to what was installed
fpac() {
    pacman -Slq | fzf --multi --reverse --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S
}

fyay() {
    yay -Slq | fzf --multi --reverse --preview 'yay -Si {1}' | xargs -ro yay -S
}

# +------+
# | tmux |
# +------+

fmux() {
    prj=$(find $XDG_CONFIG_HOME/tmuxp/ -execdir bash -c 'basename "${0%.*}"' {} ';' | sort | uniq | nl | fzf | cut -f 2)
    echo $prj
    [ -n "$prj" ] && tmuxp load $prj
}

# ftmuxp - propose every possible tmuxp session
ftmuxp() {
    if [[ -n $TMUX ]]; then
        return
    fi

    # get the IDs
    ID="$(ls $XDG_CONFIG_HOME/tmuxp | sed -e 's/\.yml$//')"
    if [[ -z "$ID" ]]; then
        tmux new-session
    fi

    create_new_session="Create New Session"

    ID="${create_new_session}\n$ID"
    ID="$(echo $ID | fzf | cut -d: -f1)"

    if [[ "$ID" = "${create_new_session}" ]]; then
        tmux new-session
    elif [[ -n "$ID" ]]; then
        # Change name of urxvt tab to session name
        printf '\033]777;tabbedx;set_tab_name;%s\007' "$ID"
        tmuxp load "$ID"
    fi
}

# ftmux - help you choose tmux sessions
ftmux() {
    if [[ ! -n $TMUX ]]; then
        # get the IDs
        ID="`tmux list-sessions`"
        if [[ -z "$ID" ]]; then
            tmux new-session
        fi
        create_new_session="Create New Session"
        ID="$ID\n${create_new_session}:"
        ID="`echo $ID | fzf | cut -d: -f1`"
        if [[ "$ID" = "${create_new_session}" ]]; then
            tmux new-session
        elif [[ -n "$ID" ]]; then
            printf '\033]777;tabbedx;set_tab_name;%s\007' "$ID"
            tmux attach-session -t "$ID"
        else
            :  # Start terminal normally
        fi
    fi
}

# +-------+
# | Other |
# +-------+

# List install files for dotfiles
fdot() {
    file=$(find "$DOTFILES/install" -exec basename {} ';' | sort | uniq | nl | fzf | cut -f 2)
    [ -n "$file" ] && "$EDITOR" "$DOTFILES/install/$file"
}

# List projects
fwork() {
    result=$(find ~/workspace/* -type d -prune -exec basename {} ';' | sort | uniq | nl | fzf | cut -f 2)
    [ -n "$result" ] && cd ~/workspace/$result
}

# Open pdf with Zathura
fpdf() {
    result=$(find -type f -name '*.pdf' | fzf --bind "ctrl-r:reload(find -type f -name '*.pdf')" --preview "pdftotext {} - | less")
    [ -n "$result" ] && nohup zathura "$result" &> /dev/null & disown
}

# Open epubs with Zathura
fepub() {
    result=$(find -type f -name '*.epub' | fzf --bind "ctrl-r:reload(find -type f -name '*.epub')")
    [ -n "$result" ] && nohup zathura "$result" &> /dev/null & disown
}

# Open freemind mindmap
fmind() {
    local folders=("$CLOUD/knowledge_base" "$WORKSPACE/alexandria")

    files=""
    for root in ${folders[@]}; do
        files="$files $(find $root -name '*.mm')"
    done
    result=$(echo "$files" | fzf -m --height 60% --border sharp | tr -s "\n" " ")
    [ -n "$result" ] && nohup freemind $(echo $result) &> /dev/null & disown
}

# List tracking spreadsheets (productivity, money ...)
ftrack() {
    file=$(ls $CLOUD/tracking/**/*.{ods,csv} | fzf) || return
    [ -n "$file" ] && libreoffice "$file" &> /dev/null &
}

# Search and find directories in the dir stack
fpop() {
    # Only work with alias d defined as:

    # alias d='dirs -v'
    # for index ({1..9}) alias "$index"="cd +${index}"; unset index

    d | fzf --height="20%" | cut -f 1 | source /dev/stdin
}


function ip() {
    network=`current_networkservice`
    networksetup -getinfo $network | grep '^IP address' | awk -F: '{print $2}' | sed 's/ //g'
}
ssh-create() {
    if [ ! -z "$1" ]; then
        ssh-keygen -f $HOME/.ssh/$1 -t rsa -N '' -C "$1"
        chmod 700 $HOME/.ssh/$1*
    fi
}
historystat() {
    history 0 | awk '{print $2}' | sort | uniq -c | sort -n -r | head
}

promptspeed() {
    for i in $(seq 1 10); do /usr/bin/time zsh -i -c exit; done
}
matrix () {
    local lines=$(tput lines)
    cols=$(tput cols)

    awkscript='
    {
        letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"
        lines=$1
        random_col=$3
        c=$4
        letter=substr(letters,c,1)
        cols[random_col]=0;
        for (col in cols) {
            line=cols[col];
            cols[col]=cols[col]+1;
            printf "\033[%s;%sH\033[2;32m%s", line, col, letter;
            printf "\033[%s;%sH\033[1;37m%s\033[0;0H", cols[col], col, letter;
            if (cols[col] >= lines) {
                cols[col]=0;
            }
    }
}
'

echo -e "\e[1;40m"
clear

while :; do
    echo $lines $cols $(( $RANDOM % $cols)) $(( $RANDOM % 72 ))
    sleep 0.05
done | awk "$awkscript"
}
# Follow this page to avoid enter password
# http://apple.stackexchange.com/questions/236806/prevent-networksetup-from-asking-for-password
function proxy() {
    network=`current_networkservice`
    if [ -z network ]; then
        echo "Unrecognized network"
        return 1
    fi

    case "$1" in
    on)
        networksetup -setwebproxystate $network on;
        networksetup -setsecurewebproxystate $network on;
        networksetup -setwebproxy $network 127.0.0.1 8888;
        networksetup -setsecurewebproxy $network 127.0.0.1 8888;
        networksetup -setautoproxystate $network off;
        networksetup -setsocksfirewallproxystate $network off;
        ;;
    g)
        networksetup -setwebproxystate $network off;
        networksetup -setsecurewebproxystate  $network off;
        networksetup -setautoproxystate $network off;
        networksetup -setsocksfirewallproxy "$network" localhost 14179
        ;;
    off)
        networksetup -setwebproxystate $network off;
        networksetup -setsecurewebproxystate  $network off;
        networksetup -setautoproxystate $network off;
        networksetup -setsocksfirewallproxystate $network off;
        ;;
    s)
        socks_status=$(networksetup -getsocksfirewallproxy $network | head -n 3;)
        socks_enable=$(echo $socks_status | head -n 1 | awk '{print $2}')
        socks_ip=$(echo $socks_status | head -n 2 | tail -n 1 | awk '{print $2}')
        socks_port=$(echo $socks_status | tail -n 1 | awk '{print $2}')

        if [ "$socks_enable" = "Yes" ]; then
            echo -e "${green}Socks: ✔${NC}" $socks_ip ":" $socks_port
        else
            echo -e "${RED}Socks: ✘${NC}" $socks_ip ":" $socks_port
        fi

        http_status=$(networksetup -getwebproxy $network | head -n 3)
        http_enable=$(echo $http_status | head -n 1 | awk '{print $2}')
        http_ip=$(echo $http_status | head -n 2 | tail -n 1 | awk '{print $2}')
        http_port=$(echo $http_status | tail -n 1 | awk '{print $2}')

        if [ "$http_enable" = "Yes" ]; then
            echo -e "${green}HTTP : ✔${NC}" $http_ip ":" $http_port
        else
            echo -e "${RED}HTTP : ✘${NC}" $http_ip ":" $http_port
        fi

        https_status=$(networksetup -getsecurewebproxy $network | head -n 3)
        https_enable=$(echo $https_status | head -n 1 | awk '{print $2}')
        https_ip=$(echo $https_status | head -n 2 | tail -n 1 | awk '{print $2}')
        https_port=$(echo $https_status | tail -n 1 | awk '{print $2}')

        if [ "$https_enable" = "Yes" ]; then
            echo -e "${green}HTTPS: ✔${NC}" $https_ip ":" $https_port
        else
            echo -e "${RED}HTTPS: ✘${NC}" $https_ip ":" $https_port
        fi
        ;;
    *)
        echo "Usage: p {on|off|g|s}"
        echo "p on : Set proxy to Charles(port 8888)"
        echo "p off: Reset proxy to system default"
        echo "p g  : Set proxy to GoAgentx(port 14179)"
        echo "p s  : Show current network proxy status"
        echo "p *  : Show usage"
        ;;
    esac
}
## Enable/Disable proxy
function proxyon() {
  # local host_port='127.0.0.1:8080'
  export all_proxy="socks5://127.0.0.1:7891"
  export http_proxy=$all_proxy
  export https_proxy=$all_proxy
  git config --global http.proxy $https_proxy
  git config --global https.proxy $https_proxy
  echo "proxy = \"$all_proxy\"" >! $HOME/.config/curl/config
}

function proxyoff() {
  export all_proxy=''
  export http_proxy=''
  export https_proxy=''
  git config --global http.proxy ''
  git config --global https.proxy ''
  echo '' >! $HOME/.config/curl/config
}
## Reload shell
function reload() {
  local compdump_files="$ZDOTDIR/.zcompdump*"

  if ls $compdump_files &> /dev/null; then
      rm -f $compdump_files
  fi

  exec $SHELL -l
}
## Generate a secure password
function passgen() {
  LC_ALL=C tr -dc ${1:-"[:graph:]"} < /dev/urandom | head -c ${2:-20}
}
## Encode/Decode string using base64
function b64e() {
  echo "$@" | base64
}

function b64d() {
  echo "$@" | base64 -D
}
# Search through all man pages
function fman() {
    man -k . | fzf -q "$1" --prompt='man> '  --preview $'echo {} | tr -d \'()\' | awk \'{printf "%s ", $2} {print $1}\' | xargs -r man' | tr -d '()' | awk '{printf "%s ", $2} {print $1}' | xargs -r man
}
# Back up a file. Usage "backupthis <filename>"
backupthis() {
    cp -riv $1 ${1}-$(date +%Y%m%d%H%M).backup;
}

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

# Tmux layout
openSession () {
    tmux split-window -h -t
    tmux split-window -v -t
    tmux resize-pane -U 5
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

ports() {
    sudo netstat -tulpn | grep LISTEN | fzf;
}
