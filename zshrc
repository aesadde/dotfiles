# === [ Global ] === {{{1
# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd extendedglob

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="afowler"

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
ENABLE_CORRECTION="true"

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

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git brew vi-mode pip kube-ps1)

# User configuration

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

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
if [[ -d /usr/local/go ]]; then
  export PATH=/usr/local/go/bin:$PATH
fi
if [[ -d $HOME/goprojects ]]; then
  export GOPATH="$HOME/goprojects"
  export PATH=$PATH:$GOPATH/bin
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
if [[ -d $HOME/anaconda3 ]]; then
  export PATH="$HOME/anaconda3/bin:$PATH"
fi
#2}}}

# ===[ OS specific ]=== {{{1
if [ "$OSTYPE" = 'Darwin' ]; then
    [[ -f $DOTF/aliases.local ]] && source $DOTF/aliases.local
    #TeX
    export PATH=/Library/TeX/texbin:$PATH
    # activate syntax highlighting on terminal
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
    [ -f /Users/alberto/Library/Android/sdk ] && export PATH=$PATH:/Users/alberto/Library/Android/sdk

    #Homebrew path - tests that homebrew works and adds prepends /usr/local/bin to clean path
    test -x /usr/local/bin/brew && export PATH=/usr/local/bin:`echo ":$PATH:" | sed -e "s:\:/usr/local/bin\::\::g" -e "s/^://" -e "s/:$//"`
    if [ -f /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi

    # Initialze Conda
    __conda_setup="$('/Users/aesadde/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
      eval "$__conda_setup"
    else
      if [ -f "/Users/aesadde/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/aesadde/miniconda3/etc/profile.d/conda.sh"
      else
        export PATH="/Users/aesadde/miniconda3/bin:$PATH"
      fi
    fi
    unset __conda_setup

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
