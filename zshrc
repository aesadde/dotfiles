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
# Load immediately for instant prompt
zinit ice depth=1
zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
#2}}}

# === [ Zinit Plugins ] === {{{2
# Essential plugins with turbo mode (deferred loading for faster startup)
# -C: skip security check, -i: ignore errors for missing completion files
zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]='-C -i'; zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    blockf \
        zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions

# Oh-my-zsh plugins (only essentials, deferred)
zinit wait lucid for \
    OMZP::git \
    OMZP::kubectl \
    OMZP::docker \
    OMZP::vi-mode \
    OMZP::terraform \
    OMZP::kube-ps1

# FZF-tab for better completions
zinit wait lucid for \
    Aloxaf/fzf-tab
#2}}}

# === [ Completion Configuration ] === {{{2
# Do menu-driven completion
zstyle ':completion:*' menu select

# Color completion using LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# Disable sort when completing git checkout
zstyle ':completion:*:git-checkout:*' sort false

# Preview directory content with lsd when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath'

# Switch group using , and .
zstyle ':fzf-tab:*' switch-group ',' '.'

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
#2}}}

# === [ Kube Prompt ] === {{{2
KUBE_PS1_SYMBOL_USE_IMG=true
#2}}}

# === [ Editor ] === {{{2
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi
#2}}}
#1}}}

# === [ Config ] === {{{1
OSTYPE="$(uname -s)"
ARCH="$(uname -m)"
DOTF="$HOME/dotfiles"

# vi editing mode
set -o vi

# vi style incremental search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
#1}}}

# === [ Global Exports ] === {{{1
# Shell colors
export CLICOLOR=1
export LSCOLORS=dxgxcxdxcxegedacagacad

export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$DOTF/scripts"
export VIM_VIKI_HOME="$HOME/Projects/wiki"
export VIM_VIKI_PLAN="$HOME/Projects/PLAN"

# Source custom files
[ -r "$DOTF/customFunctions" ] && [ -f "$DOTF/customFunctions" ] && source "$DOTF/customFunctions"
[[ -f "$DOTF/aliases" ]] && source "$DOTF/aliases"
[[ -f "$HOME/.local_settings" ]] && source "$HOME/.local_settings"

# Golang Path (cached to avoid slow brew --prefix on every shell start)
export GOROOT="/opt/homebrew/opt/go/libexec"
export PATH="$PATH:$GOROOT/bin"

if [[ -d "$HOME/goprojects" ]]; then
    export GOPATH="$HOME/goprojects"
else
    export GOPATH="$HOME/go"
fi
export PATH="$PATH:$GOPATH/bin"

[[ -d /usr/local/go ]] && export PATH="/usr/local/go/bin:$PATH"
#1}}}

# === [ FZF Configuration ] === {{{1
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# FZF with ripgrep
if command -v rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

export FZF_DEFAULT_OPTS="--layout=reverse --border --height=40%"

# Better preview with bat if available
if command -v bat &> /dev/null; then
    export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {} 2>/dev/null || cat {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
else
    export FZF_CTRL_T_OPTS="--preview '(cat {} || tree -C {}) 2>/dev/null | head -200'"
fi

export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-/:toggle-preview'"
export FZF_ALT_C_OPTS="--preview 'lsd --tree --color=always {} 2>/dev/null | head -200'"
#1}}}

# === [ Conda - Lazy Loaded ] === {{{1
# Lazy-load conda to speed up shell startup (~200-400ms savings)
conda() {
    unfunction conda 2>/dev/null
    __conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
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

# === [ OS Specific ] === {{{1
if [ "$OSTYPE" = 'Darwin' ]; then
    [[ -f "$DOTF/aliases.local" ]] && source "$DOTF/aliases.local"
    [[ -f "$DOTF/kaliases" ]] && source "$DOTF/kaliases"

    # TeX
    export PATH="/Library/TeX/texbin:$PATH"

    # RVM
    export PATH="$PATH:$HOME/.rvm/bin"

    # Android SDK (if exists)
    [[ -d "$HOME/Library/Android/sdk" ]] && export PATH="$PATH:$HOME/Library/Android/sdk"

    # Homebrew (Apple Silicon) - set paths directly instead of slow eval
    export HOMEBREW_PREFIX="/opt/homebrew"
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
    export HOMEBREW_REPOSITORY="/opt/homebrew"
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
    export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

elif [ "$OSTYPE" = 'Linux' ]; then
    export LD_LIBRARY_PATH="$HOME/local/lib:/lib:/lib64:$LD_LIBRARY_PATH"
    export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
    command -v kubectl &> /dev/null && source <(kubectl completion zsh)
fi
#1}}}

# === [ Additional Tools ] === {{{1
# Google Cloud SDK
[[ -f "$HOME/.local/google-cloud-sdk/path.zsh.inc" ]] && source "$HOME/.local/google-cloud-sdk/path.zsh.inc"
[[ -f "$HOME/.local/google-cloud-sdk/completion.zsh.inc" ]] && source "$HOME/.local/google-cloud-sdk/completion.zsh.inc"

# Yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Java
export JAVA_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home"

# Git-fuzzy (if exists)
[[ -d "$HOME/.local/git-fuzzy/bin" ]] && export PATH="$HOME/.local/git-fuzzy/bin:$PATH"

# Linkerd (if exists)
[[ -d "$HOME/.linkerd2/bin" ]] && export PATH="$PATH:$HOME/.linkerd2/bin"

# GHCup (Haskell) - just add to PATH, don't source the slow env file
[[ -d "$HOME/.ghcup/bin" ]] && export PATH="$HOME/.ghcup/bin:$PATH"

# GVM (Go Version Manager) - lazy load
gvm() {
    unfunction gvm 2>/dev/null
    [[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
    gvm "$@"
}

# Colima Docker
export DOCKER_HOST="unix://$HOME/.colima/docker.sock"

# GitHub Copilot CLI - lazy load (very slow ~300ms)
ghcs() {
    unfunction ghcs 2>/dev/null
    eval "$(github-copilot-cli alias -- zsh)"
    ghcs "$@"
}
ghce() {
    unfunction ghce 2>/dev/null
    eval "$(github-copilot-cli alias -- zsh)"
    ghce "$@"
}

# Windsurf (if exists)
[[ -d "$HOME/.codeium/windsurf/bin" ]] && export PATH="$HOME/.codeium/windsurf/bin:$PATH"

# Try - lazy load
t() {
    unfunction t 2>/dev/null
    eval "$(try init ~/repos/tries)"
    try "$@"
}
#1}}}
