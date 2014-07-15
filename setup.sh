#!/usr/bin/env bash 
#===============================================================================
#          FILE: setup.sh
#         USAGE: ./setup.sh 
# 
#   DESCRIPTION: Setup dotfiles 
# 
#       OPTIONS: -h usage, -all all dotfiles, -vim just vim files, -bash just bash files
#  REQUIREMENTS: bash, vim 7+
#          BUGS: 
#         NOTES: =D
#        AUTHOR: Alberto Sadde
#       CREATED: 03/15/2014 20:35
#       VeRSION: 0.1
#===============================================================================

#Variables: {{{1
DOTFILES_ROOT=$PWD
#}}}

#Functions: All functions are declared here {{{1

#Function: usage() prints the usage instructions {{{2
function usage() { 
    echo -e "Need to select at least one option\n"
    echo -e "-h for help\n-all for all dotfiles\n-vim just for vim dotfiles\n-bash just for bash dotfiles\n-git for git dotfiles\n-clean to remove old dotfiles"
    exit 1
}
#2}}}

#Function: parseOptions() parses the options selected by user {{{2
function parseOptions() {
case "$1" in
    -h) 
        usage
        ;;
    -all)
        all
        ;;
    -vim)
        vimFiles
        ;;
    -bash) 
        bashFiles
        ;; 
    -git)
        gitFiles
        ;;
    -clean)
        removeOldDotFiles
        ;;
esac
}
#2}}}

#Function: removeOldDotFiles() cleans up home directory from old dotfiles if they exist {{{2
function removeOldDotFiles() {
    for file in $HOME/.{tmux.conf,pentadactylrc,gitignore,gitconfig,gitattributes,bash_profile,aliases,bashrc,exports,vimrc,vim,customFunctions}; do
        if [ -f $file ]; then
            rm $file
        fi
    done
}
#2}}}

#Function: bashFiles() sets the bash dotfiles {{{2
function bashFiles() {
    for file in {bash_profile,bashrc,pentadactylrc,tmux.conf}; do
        if [ -f $HOME/.$file ]; then
            rm $HOME/.$file
        fi

        ln -s $DOTFILES_ROOT/$file $HOME/.$file
    done
    unset file
    echo -e "All dotfiles up and running!\n"
}
#2}}}

#Function: vimFiles() sets .vimrc and .vim {{{2
function vimFiles() {
    git submodule init; git submodule update
    cd $DOTFILES_ROOT/vim
    exec $PWD/vimsetup.sh
    echo -e "Vim files and plugins up and running!\n"
}
#2}}}

#Function: gitFiles() sets global git config dotfiles {{{2
function gitFiles() {
echo $DOTFILES_ROOT
for file in {gitignore,gitattributes,gitconfig}; do
    if [ -f $HOME/.$file ]; then
        rm $HOME/.$file
    fi

    ln -s $DOTFILES_ROOT/$file $HOME/.$file
done
unset file
echo -e "All git config files up and running!\n"
}
#2}}}

#Function: all() sets all dotfiles {{{2
function all() {
bashFiles
vimFiles
gitFiles
}
#2}}}
#}}}

#Main: {{{
# check we are given at least one parameter
[[ $# -ne 1 ]] && usage
parseOptions $1
#}}}

