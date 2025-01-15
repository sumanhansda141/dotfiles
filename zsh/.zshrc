export EDITOR="nvim"
export VISUAL="nvim"

alias ls="lsd"
alias ll="ls -aFl"
alias tree="lsd --tree"
alias lf="yazi"
alias tmux="tmux -u"
alias ti="tmux-init"
alias ta="tmux a"
alias btop="btop --utf-force"
alias grep="grep --color=auto"

#vim keybinding
bindkey -v
export KEYTIMEOUT=1
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
  bindkey -M $km -- '-' vi-up-line-or-history
  for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
    bindkey -M $km $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $km $c select-bracketed
  done
done
#using hjkl to navigate completion menu
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# tmux-sessionizer
bindkey -s '^F' 'sessionizer\n'

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Catppuccin colorscheme for fzf
export FZF_DEFAULT_OPTS=" \
  --prompt '❯ '
  --height=40% \
  --layout=reverse \
  --info=inline \
  --border \
  --color=fg:#e5e9f0,hl:#81a1c1
  --color=fg+:#e5e9f0,bg+:#2E3440,hl+:#81a1c1
  --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
  --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b
  --multi"

source "$HOME/opt/dotfiles/zsh/completion.zsh"
source "$HOME/opt/dotfiles/zsh/prompt.zsh"
eval "$(zoxide init --cmd cd zsh)"
if [ -x "$(command -v fzf)"  ]
then
    source /usr/share/doc/fzf/examples/key-bindings.zsh 
fi

# fnm
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env)"
fi
