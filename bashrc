# GENERAL
PS1='\e[0;33m\n[\e[0;35m\u-\e[0;33m\W]\$\e[0;37m'
#sudo prompt
SUDO_PS1='[\u@\h \W]\$'

#keeping everything clean so source all the files
for file in ~/.{aliases,exports}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

#some nice options for using the shell
#vi editing mode
set -o vi

#Case insensitive globbing for pathname expansion
shopt -s nocaseglob

#Append to history file
shopt -s histappend

#Autocorrect typos in path names when using cd
shopt -s cdspell

#expand aliases
shopt -s expand_aliases

# if possible activate tab completion for more stuff
[ -f /etc/bash_completion ] && source /etc/bash_completion
