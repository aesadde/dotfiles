# === [ Global ] === {{{1
# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
REPORTTIME=1

setopt appendhistory autocd extendedglob
autoload -U compinit
autoload -U +X bashcompinit && bashcompinit
compinit

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="powerlevel10k/powerlevel10k"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# cd without the command 'cd foo -> foo'
setopt AUTO_CD

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Add wisely, as too many plugins slow down shell startup.
plugins=(git macos vi-mode pip kubectl kube-ps1 encode64 docker terraform fzf fzf-tab)

# User configuration
# # Do menu-driven completion.
zstyle ':completion:*' menu select

# Color completion for some things.
# http://linuxshellaccount.blogspot.com/2008/12/color-completion-using-zsh-modules-on.html
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# formatting and messages
# http://www.masterzen.fr/2009/04/19/in-love-with-zsh-part-one/
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

source $ZSH/oh-my-zsh.sh

# Add Kube prompt
KUBE_PS1_SYMBOL_USE_IMG=true
PROMPT=$PROMPT'$(kube_ps1) '


# Preferred editor for local and remote sessions
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi
#1}}}

# === [ config ] === {{{1
OSTYPE="$(uname -s)"
ARCH="$(uname -m)"
DOTF="$HOME/dotfiles"

#vi editing mode
set -o vi
#
# vi style incremental search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^c" kill-line

# === [ Global Exports ]=== {{{2
#Shell colors
export CLICOLOR=1
export LSCOLORS=dxgxcxdxcxegedacagacad

export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$DOTF/scripts"
export VIM_VIKI_HOME="$HOME/Projects/wiki"
export VIM_VIKI_PLAN="$HOME/Projects/PLAN"
#
# Keeping everything clean. Source all the files
[ -r $DOTF/customFunctions ] && [ -f $DOTF/customFunctions ] && source $DOTF/customFunctions
[[ -f $DOTF/aliases ]] && source $DOTF/aliases
[[ -f $HOME/.local_settings ]] && source $HOME/.local_settings

# Golang Path
export GOROOT="$(brew --prefix golang)/libexec"
export PATH=$PATH:$GOROOT/bin

if [[ -d $HOME/goprojects ]]; then
  export GOPATH="$HOME/goprojects"
else
  export GOPATH="$HOME/go"
fi
export PATH=$PATH:$GOPATH/bin

if [[ -d /usr/local/go ]]; then
  export PATH=/usr/local/go/bin:$PATH
fi


# fzf via Homebrew
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ -e /usr/local/opt/fzf/shell/completion.zsh ]; then
  source /usr/local/opt/fzf/shell/key-bindings.zsh
  source /usr/local/opt/fzf/shell/completion.zsh

  if [ $(which rg) ]; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
  export FZF_CTRL_T_OPTS="--select-1 --exit-0 --preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
  export FZF_DEFAULT_OPTS="--layout=reverse --border"
fi

# Anaconda Environments
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
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
# <<< conda initialize <<<
#2}}}

# ===[ OS specific ]=== {{{1
if [ "$OSTYPE" = 'Darwin' ]; then
  [[ -f $DOTF/aliases.local ]] && source $DOTF/aliases.local
  [[ -f $DOTF/kaliases ]] && source $DOTF/kaliases;
  #TeX
  export PATH=/Library/TeX/texbin:$PATH

  export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
  [ -f /Users/alberto/Library/Android/sdk ] && export PATH=$PATH:/Users/alberto/Library/Android/sdk

    #Homebrew path - tests that homebrew works and adds prepends /usr/local/bin to clean path
    test -x /usr/local/bin/brew && export PATH=/usr/local/bin:`echo ":$PATH:" | sed -e "s:\:/usr/local/bin\::\::g" -e "s/^://" -e "s/:$//"`

  elif [ "$OSTYPE" = 'Linux' ]; then
    export LD_LIBRARY_PATH="$HOME/local/lib:/lib:/lib64:$LD_LIBRARY_PATH"
    export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
    if [ /usr/bin/kubectl ]; then source <(kubectl completion zsh); fi

  elif [ "$(expr substr $OSTYPE 1 10)" == "MINGW32_NT" ]; then
    export EDITOR="/c/Program\ Files\ (x86)/Vim/vim74/gvim.exe"
fi
#1}}}
#1}}}

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/.local/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/.local/google-cloud-sdk/completion.zsh.inc"; fi
if [ -f "$HOME/.local/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/.local/google-cloud-sdk/path.zsh.inc"; fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

## JAVA OPTIONS - For other versions check the aliases setJDK*
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home

export PATH="/Users/aesadde/.local/git-fuzzy/bin:$PATH"


complete -o nospace -C /usr/local/bin/kustomize kustomize

# # Use docker runtime to build docker images with minikube
# eval $(minikube docker-env)

# linkerd
export PATH=$PATH:/Users/aesadde/.linkerd2/bin

[ -f "/Users/aesadde/.ghcup/env" ] && source "/Users/aesadde/.ghcup/env" # ghcup-env




