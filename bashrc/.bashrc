[[ $- != *i* ]] && return

# Shell Options
# ------------
# Enable checking window size after each command
shopt -s checkwinsize

# Append to history instead of overwriting
shopt -s histappend

# Autocorrect minor spelling errors in cd command
shopt -s cdspell

# Enable extended globbing
shopt -s extglob

# Save multi-line commands as a single entry
shopt -s cmdhist

# History Configuration
# --------------------
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"
HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "

# Environment Variables
# --------------------
export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="firefox"

# Path Additions
# --------------
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.local/share/go/bin"
export PATH="$PATH:/usr/local/go"
export PATH="$PATH:$HOME/opt/jdk-21.0.1+12/bin"
export GOPATH="$HOME/.local/share/go"
export PATH="$PATH:$HOME/.config/scripts"

# Development Environment Setup
# ----------------------------
# Rust
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

#FNM
FNM_PATH="/home/suman/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env)"
fi

# Prompt Configuration
# -------------------
# PS1=" \033[1m\w\033[0m \e[0;32m❯\e[0;36m❯\e[0;34m❯ \e[0m"

# Git information function
parse_git_info() {
    git rev-parse --is-inside-work-tree &>/dev/null || return

    local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        local git_status=$(git status --porcelain 2>/dev/null)
        local ahead_behind=$(git rev-list --count --left-right '@{upstream}...HEAD' 2>/dev/null)
        local git_color="\033[01;35m" # Default to purple
        local status_indicator=""

        # Check if there are uncommitted changes
        if [ -n "$git_status" ]; then
            git_color="\033[01;31m" # Red if there are uncommitted changes
            status_indicator="*"
        fi

        # Check if ahead/behind remote
        if [ -n "$ahead_behind" ]; then
            local ahead_behind=(${ahead_behind//[^0-9]/ })
            if [ "${ahead_behind[0]:-0}" -ne 0 ]; then
                branch+=" ↓${ahead_behind[0]}"
            fi
            if [ "${ahead_behind[1]:-0}" -ne 0 ]; then
                branch+=" ↑${ahead_behind[1]}"
            fi
        fi

        printf "(%s%s%s\033[00m)" "$git_color" "$branch" "$status_indicator"
    fi
}

# Function to set the prompt
set_bash_prompt() {
    PROMPT_DIRTRIM=3
    PS1="\033[1;32m\w\033[0m $(parse_git_info)\n\`if [ \$? = 0 ]; then echo \[\e[36m\]➜ \[\e[0m\]; else echo \[\e[31m\✗ \[\e[0m\]; fi\` "
    printf "\n"
}

# Set up color prompt
color_prompt=yes

if [ "$color_prompt" = yes ]; then
    PROMPT_COMMAND=set_bash_prompt

    PROMPT_DIRTRIM=3
    PS1='\w $(parse_git_info) '
    unset color_prompt force_color_prompt
fi

# Tool Integrations
# ----------------
# Zoxide (smart cd replacement)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init --cmd cd bash)"
fi

# FZF Configuration
if command -v fzf &>/dev/null; then
  source /usr/share/doc/fzf/examples/key-bindings.bash

  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

  # Catppuccin-inspired FZF theme
  export FZF_DEFAULT_OPTS=" \
      --info=inline
      --color=fg+:#f8f8f2,bg+:#3e3d32,hl+:#f92672
      --color=info:#75715e,prompt:#66d9ef,pointer:#f92672
      --color=marker:#a6e22e,spinner:#f92672,header:#75715e
      --color=border:#75715e
      --border
      --height 40%
      --layout=reverse
      --prompt '∼ '
      --pointer '▶'
      --marker '✓'
      --multi"
fi

# Bash Completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# Load local aliases if they exist
[ -f ~/.bash_aliases ] && source ~/.bash_aliases

# Vi mode for command line
set -o vi

# SDKMAN configuration
export SDKMAN_DIR="${HOME}/.sdkman"
if [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]]; then
    source "${SDKMAN_DIR}/bin/sdkman-init.sh"
fi
