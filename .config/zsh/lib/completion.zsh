# Auto-completion
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit;
else
    compinit -C;
fi;

# Accept completion with <tab> or Ctrl+i and go to next/previous suggestions with Vi like keys: Ctrl+n/p
zmodload -i zsh/complist
accept-and-complete-next-history() {
    zle expand-or-complete-prefix
}

zstyle ':completion:*' menu select=1

zstyle ':completion:*:directory-stack' list-colors '=(#b) #([0-9]#)*( *)==95=38;5;12'

zle -N accept-and-complete-next-history
bindkey -M menuselect '^i' accept-and-complete-next-history
bindkey '^n' expand-or-complete
bindkey '^p' reverse-menu-complete
zstyle ':completion:*' menu select=1
