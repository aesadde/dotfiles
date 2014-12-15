# ===[ Variables ]=== {{{1
OSTYPE="$(uname -s)"
ARCH="$(uname -m)"
DOTF="$HOME/dotfiles"
#1}}}
# ===[ Global options ]=== {{{1
#Append to history file
shopt -s histappend

#Autocorrect typos in path names when using cd
shopt -s cdspell

#expand aliases
shopt -s expand_aliases

#vi editing mode
set -o vi

#Case insensitive globbing for pathname expansion
#doesn't work in windows (msys)
shopt -s nocaseglob

#Shell colors
export CLICOLOR=1
export LSCOLORS=dxgxcxdxcxegedacagacad

#keeping everything clean. Source all the files
[ -r $DOTF/customFunctions ] && [ -f $DOTF/customFunctions ] && source $DOTF/customFunctions
[[ -f $DOTF/aliases ]] && source $DOTF/aliases
#1}}}
# ===[ OS specific ]=== {{{1
if [ $OSTYPE == "Darwin" ]; then
    [[ -f $DOTF/osx.settings ]] && source $DOTF/osx.settings
    [[ -f $DOTF/aliases.local ]] && source $DOTF/aliases.local

elif [ $OSTYPE == "Linux" ]; then
    echo "linux settings set"
    #ldcAliases
    export PATH="$HOME/local/bin:$PATH"
    export LD_LIBRARY_PATH="$HOME/local/lib:/lib:/lib64"
    export PS1='\e[0;35m\u-\e[0;33m\W $\e[0;37m'

elif [ "$(expr substr $OSTYPE 1 10)" == "MINGW32_NT" ]; then
    export EDITOR="/c/Program\ Files\ (x86)/Vim/vim74/gvim.exe"
fi
#1}}}
