# === [ Powerlevel10k Instant Prompt ] === {{{1
# Must stay at the top. No console output above this.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
#1}}}

# === [ Global ] === {{{1
# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

# === [ History Configuration ] === {{{2
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000
REPORTTIME=1

setopt APPEND_HISTORY         # Append to history file
setopt EXTENDED_HISTORY       # Add timestamps to history
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicates first
setopt HIST_IGNORE_DUPS       # Don't record duplicates
setopt HIST_IGNORE_SPACE      # Don't record commands starting with space
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks
setopt HIST_VERIFY            # Show command before executing from history
setopt SHARE_HISTORY          # Share history between sessions
setopt INC_APPEND_HISTORY     # Write immediately, not on exit
#2}}}

# === [ General Options ] === {{{2
setopt AUTO_CD                # cd without typing cd
setopt AUTO_PUSHD             # Push directories onto stack
setopt PUSHD_IGNORE_DUPS      # Don't push duplicates
setopt PUSHD_SILENT           # Don't print stack after pushd/popd
setopt EXTENDED_GLOB          # Extended globbing
setopt INTERACTIVE_COMMENTS   # Allow comments in interactive shell
setopt NO_BEEP                # No beeping
#2}}}

# === [ Locale ] === {{{2
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
#2}}}

# === [ Zinit Installation ] === {{{2
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d "$ZINIT_HOME/.git" ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
#2}}}

# === [ Powerlevel10k Prompt ] === {{{2
zinit ice depth=1
zinit light romkatv/powerlevel10k
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
#2}}}

# === [ Zinit Plugins ] === {{{2
zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]='-C -i'; zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    blockf \
        zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions

zinit wait lucid for \
    OMZP::git \
    OMZP::docker

zinit wait lucid for \
    Aloxaf/fzf-tab
#2}}}

# === [ Completion Configuration ] === {{{2
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# Preview directory content with lsd when completing cd (falls back to ls)
if command -v lsd &>/dev/null; then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath'
else
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'
fi
#2}}}

# === [ Editor ] === {{{2
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi
#2}}}
#1}}}

# === [ Terminal Title ] === {{{1
_last_git_branch=""

_update_tmux_git_branch() {
    [[ -z "$TMUX" ]] && return
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    if [[ -n "$branch" ]]; then
        [[ "$branch" != "$_last_git_branch" ]] && tmux set-option -w @git_branch "$branch"
    else
        [[ -n "$_last_git_branch" ]] && tmux set-option -wu @git_branch
    fi
    _last_git_branch="$branch"
}

_get_pane_title() {
    local git_root
    git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ -n "$git_root" ]]; then
        basename "$git_root"
    else
        print -P '%2~'
    fi
}

_set_terminal_title() { print -Pn "\e]0;${1}\a" }

_update_title_precmd() {
    _update_tmux_git_branch
    _set_terminal_title "$(_get_pane_title)"
}

_update_title_chpwd() {
    _update_tmux_git_branch
    _set_terminal_title "$(_get_pane_title)"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _update_title_precmd
add-zsh-hook chpwd _update_title_chpwd
#1}}}

# === [ Config ] === {{{1
DOTF="$HOME/dotfiles"

# vi editing mode
set -o vi

bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
#1}}}

# === [ PATH & Exports ] === {{{1
export CLICOLOR=1
export LSCOLORS=dxgxcxdxcxegedacagacad

# Homebrew (Apple Silicon)
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$DOTF/scripts"

# Go
export GOROOT="/opt/homebrew/opt/go/libexec"
export GOPATH="${HOME}/go"
export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"

# Bun
[[ -d "$HOME/.bun/bin" ]] && export PATH="$HOME/.bun/bin:$PATH"

# Colima Docker
export DOCKER_HOST="unix://$HOME/.colima/docker.sock"

# Source custom files
[ -r "$DOTF/customFunctions" ] && source "$DOTF/customFunctions"
[[ -f "$DOTF/aliases" ]] && source "$DOTF/aliases"

# Source secrets (not tracked in git)
[[ -f ~/.env.local ]] && source ~/.env.local

# Machine-local settings
[[ -f "$HOME/.local_settings" ]] && source "$HOME/.local_settings"
#1}}}

# === [ FZF Configuration ] === {{{1
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if command -v rg &>/dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

export FZF_DEFAULT_OPTS="--layout=reverse --border --height=40%"

if command -v bat &>/dev/null; then
    export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {} 2>/dev/null || cat {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
else
    export FZF_CTRL_T_OPTS="--preview '(cat {} || tree -C {}) 2>/dev/null | head -200'"
fi

export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-/:toggle-preview'"

if command -v lsd &>/dev/null; then
    export FZF_ALT_C_OPTS="--preview 'lsd --tree --color=always {} 2>/dev/null | head -200'"
else
    export FZF_ALT_C_OPTS="--preview 'ls -1 --color=always {} 2>/dev/null | head -200'"
fi
#1}}}

# === [ Mise (runtime manager) ] === {{{1
command -v mise &>/dev/null && eval "$(mise activate zsh)"
#1}}}

# === [ Conda - Lazy Loaded ] === {{{1
conda() {
    unfunction conda 2>/dev/null
    __conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
            . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="/opt/homebrew/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    conda "$@"
}
#1}}}

# === [ Google Cloud SDK ] === {{{1
[[ -f "$HOME/.local/google-cloud-sdk/path.zsh.inc" ]] && source "$HOME/.local/google-cloud-sdk/path.zsh.inc"
[[ -f "$HOME/.local/google-cloud-sdk/completion.zsh.inc" ]] && source "$HOME/.local/google-cloud-sdk/completion.zsh.inc"
#1}}}
#
eval "$(try init ~/Dropbox/tries/)"

# Added by Raindrop installer
export PATH="$HOME/.raindrop/bin:$PATH"
# End Raindrop installer
