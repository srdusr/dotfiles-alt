
#  ███████╗███████╗██╗  ██╗██████╗  ██████╗
#  ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#    ███╔╝ ███████╗███████║██████╔╝██║
#   ███╔╝  ╚════██║██╔══██║██╔══██╗██║
#  ███████╗███████║██║  ██║██║  ██║╚██████╗
#  ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

for zsh_source in "$HOME"/.config/zsh/lib/*.zsh; do
    source $zsh_source
done

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [[ -n "$SSH_CLIENT" ]]; then
    export KEYTIMEOUT=1
else
    export KEYTIMEOUT=15
fi

# Tmux default session
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
    tmux a -t tmux || exec tmux new -s tmux && exit;
fi

# Enable various options
setopt interactive_comments beep extendedglob nomatch notify completeinword prompt_subst

# Some other useful functionalities
setopt autocd # Automatically cd into typed directory.
setopt AUTO_PUSHD   # More history for cd and use "cd -TAB"
stty intr '^q' # free Ctrl+C for copy use Ctrl+q instead
stty lnext '^-' # free Ctrl+V for paste use ^- instead
stty stop undef # Disable ctrl-s to freeze terminal.
stty start undef
#unsetopt BEEP

##########    Source Plugins, should be last    ##########
#source /usr/share/nvm/init-nvm.sh

# Load fzf keybindings and completion
source /usr/local/bin/fzf/shell/key-bindings.zsh
source /usr/local/bin/fzf/shell/completion.zsh

# Suggest aliases for commands
source ~/.config/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh

# Load zsh-syntax-highlighting
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Load fish like auto suggestions
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
