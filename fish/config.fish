# ============================================================
# Environment
# ============================================================

set -gx EDITOR nvim
set -gx VISUAL nvim

# Man page formatting (bat as pager)
set -gx MANROFFOPT "-c"
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

# Go
set -gx GOPATH $HOME/.local/share/go
fish_add_path $GOPATH/bin /usr/local/go/bin

# ============================================================
# PATH
# ============================================================

for dir in ~/.local/bin ~/.config/scripts
    if test -d $dir && not contains -- $dir $PATH
        set -p PATH $dir
    end
end

# ============================================================
# Shell behaviour
# ============================================================

function fish_greeting
    # disabled (was: fastfetch)
end

function fish_user_key_bindings
    fish_vi_key_bindings

    # hjkl for pager navigation in insert mode
    for key in h j k l
        set action (switch $key
            case h; echo backward-char
            case j; echo down-line
            case k; echo up-line
            case l; echo forward-char
        end)
        bind -M insert $key "if commandline --paging-mode; commandline -f $action; else; commandline -i $key; end"
    end

    # Ctrl+Y: accept autosuggestion (both modes)
    bind \cy accept-autosuggestion
    bind -M insert \cy accept-autosuggestion
end

# ============================================================
# Integrations
# ============================================================

# zoxide (smart cd)
if command -v zoxide &> /dev/null
    zoxide init --cmd cd fish | source
end

# fnm (Node version manager)
fnm env --use-on-cd --shell fish | source

# ASDF shims
set -l _asdf_shims (test -n "$ASDF_DATA_DIR"; and echo "$ASDF_DATA_DIR/shims"; or echo "$HOME/.asdf/shims")
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end

# Load ~/.fish_profile if present
if test -f ~/.fish_profile
    source ~/.fish_profile
end

# ============================================================
# Aliases
# ============================================================

alias ti="tmux-init"
alias ta="tmux attach"
alias tree="eza -T"
alias lf="yazi"
alias btop="btop --force-utf"
alias ovim="NVIM_APPNAME=ovim nvim"

# ============================================================
# FZF — Solaroid Dark theme
# ============================================================

fzf --fish | source

set -l fzf_colors "\
--color=bg+:#073642,bg:#002b36,spinner:#2aa198,hl:#268bd2\
,fg:#839496,header:#268bd2,info:#b58900,pointer:#2aa198\
,marker:#2aa198,fg+:#eee8d5,prompt:#b58900,hl+:#268bd2"

set -Ux FZF_DEFAULT_OPTS "\
$fzf_colors\
 --border\
 --info=inline\
 --height 40%\
 --layout=reverse\
 --prompt '∼ '\
 --pointer '▶'\
 --marker '✓'\
 --multi"
