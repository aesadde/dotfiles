#Variables: some variables used on the script {{{1
OSTYPE="$(uname -s)"
ARCH="$(uname -m)"
#}}}

#FUNCTIONS: all functions used, basically makes the bashrc more readable {{{1
#function: settingsForAl() settings that are known to work on all systems {{{2
function settingsForAll() {
#nice prompt
PS1='\e[0;33m\n[\e[0;35m\u-\e[0;33m\W]\$\e[0;37m'

#sudo prompt
SUDO_PS1='[\u@\h \W]\$'

#Append to history file
shopt -s histappend

#Autocorrect typos in path names when using cd
shopt -s cdspell

#expand aliases
shopt -s expand_aliases
}
#2}}}

#function: settings() these settings apply for all systems that are not windows {{{2
function settings() {
#vi editing mode
set -o vi

#Case insensitive globbing for pathname expansion
#doesn't work in windows (msys)
shopt -s nocaseglob

# if possible activate tab completion for more stuff
[ -f /etc/bash_completion ] && source /etc/bash_completion
}
#2}}}
#1}}}

#EXPORT FUNCTIONS: These functions set the export path for different systems {{{1

#function: winExports() exports some win paths {{{2
function winExports() {
#Editors
export EDITOR="/c/Program\ Files\ (x86)/Vim/vim74/gvim.exe"
}
#2}}}

#function: macExports() exports some mac paths {{{2
function macExports() {
#macports
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH

#editor
export EDITOR=/usr/bin/vim

# PACKAGES
#Haskell
export PATH="$HOME/.cabal/bin:$PATH";
#cabal
export PATH="$HOME/Library/Haskell/bin:$PATH"
#CUDA paths
export PATH=/Developer/NVIDIA/CUDA-5.5/bin:$PATH
}
#2}}}

#function: globalExports() system independent exports {{{2
function globalExports() {
#Shell colors
export CLICOLOR=1
export LSCOLORS=dxgxcxdxcxegedacagacad
}
#2}}}
#1}}}

# ALIASES: all aliases go here {{{1
#function: macAliases() all aliases that are mac only {{{2
function macAliases() {
alias haha='open ~/Downloads/.haha'
#hide/show .files
alias hiddentrue='defaults write com.apple.finder AppleShowAllFiles TRUE & killall Finder'
alias hiddenfalse='defaults write com.apple.finder AppleShowAllFiles FALSE & killall Finder'
#Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
#faster cds
alias dbx='cd ~/Dropbox/'
alias yrk='cd ~/Documents/York'
alias eu='cd ~/Documents/Programming/euler'
alias pr='cd ~/Documents/Programming/'
alias des='cd ~/Desktop'
}
#2}}}

#function:  ldcAliases() here only for old time's sake {{{2
function ldcAliases() {
alias ntpdate='/usr/sbin/ntpdate'
alias ldaps='ldapsearch -b dc=ldc,dc=usb,dc=ve -H ldap://ldap.ldc.usb.ve -LLLx'
alias sback='ssh alberto@sholem.ldc.usb.ve'
alias site='rsync -avur /Volumes/Alberto/Docs/site_ldc/  alberto@ldc.usb.ve:'/home/alberto/html/''
alias sldc='ssh alberto@waff.ldc.usb.ve'
}
#2}}}

#function: miscAliases() all non platform specific aliases go here {{{2
function miscAliases() {
#faster cds
alias ..='cd ..'
alias dow='cd ~/Downloads'

#commands
alias sshadd='ssh-add ~/.ssh/id_dsa'

########################### some of these were taken from: https://github.com/mathiasbynens/dotfiles/blob/master/.aliases 
# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
    colorflag="--color"
else # OS X `ls`
    colorflag="-G"
fi

#LS aliases
alias lx='ls -lXB'         #  Sort by extension.
alias lk='ls -lSr'         #  Sort by size, biggest last.
alias lt='ls -ltr'         #  Sort by date, most recent last.
alias lc='ls -ltcr'        #  Sort by/show change time,most recent last.
alias lu='ls -ltur'        #  Sort by/show access time,most recent last.
#show only matchin files/dirs
alias lg='ls -la | grep'
#  List only directories
alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"
# List all files colorized in long format, including dot files
alias la="ls -laF ${colorflag}"

#Git aliases (git specific aliases are in gitconfig)
alias g?='git status'
}
#2}}}
#1}}}

# 'MAIN' {{{1
function main() {
if [ $OSTYPE == "Darwin" ]; then
    macExports
    macAliases
    settings
    #echo "Mac settings set"

elif [ $OSTYPE == "Linux" ]; then
    echo "linux settings set"
    #ldcAliases
    settings
    export PATH="/home/atc/sadde/local/bin:$PATH"
    export LD_LIBRARY_PATH="$HOME/local/lib:/lib:/lib64"

elif [ "$(expr substr $OSTYPE 1 10)" == "MINGW32_NT" ]; then
    winExports

    #echo "windows settings set"
fi

#keeping everything clean so source all the files
#for file in ~/.aliases; do
#[ -r "$file" ] && [ -f "$file" ] && source "$file"
# Load some customfunctions
[ -r "$HOME/.customFunctions" ] && [ -f "$HOME/.customFunctions" ] && source "$HOME/.customFunctions"
#done
#unset file

globalExports
miscAliases
settingsForAll
}
#1}}}

main
