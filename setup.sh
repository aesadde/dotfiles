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
#}}}

#Functions: All functions are declared here {{{1
function usage() {
    echo -e "Need to select at least one option\n"
    echo -e "-h for help\n-all for all dotfiles\n-vim just for vim dotfiles\n-bash just for bash dotfiles\n-clean to remove old dotfiles"
    exit 1
}

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
    -clean)
        removeOldDotFiles
        ;;
esac
}

function removeOldDotFiles() {
    for file in $HOME/.{bash_profile,aliases,bashrc,exports,vimrc}; do
        rm $file
    done

    rm -rf $HOME/.vim
}

function bashFiles() {
    for file in {bash_profile,aliases,bashrc,exports}; do
        if [ -f $HOME/.$file ]; then
            rm $HOME/.$file
        fi

        ln -s $PWD/$file $HOME/.$file;
    done
    unset file
    echo -e "All dotfiles up and running!\n"
}

function vimFiles() {
    cd $PWD/vim
    exec $PWD/vimrc.sh
    echo -e "Vim files and plugins up and running!\n"
}

function all() {
bashFiles
vimFiles
}
#}}}

#Main: {{{
# check we are given at least one parameter
[[ $# -ne 1 ]] && usage
parseOptions $1
#}}}

