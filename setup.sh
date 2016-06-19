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
    -nvim)
        nvimFiles
        ;;
    -vimperator)
        vimperator
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
    -osx)
      .$DOTFILES_ROOT/osx
esac
}
#2}}}

#Function: removeOldDotFiles() cleans up home directory from old dotfiles if they exist {{{2
function removeOldDotFiles() {
    for file in $HOME/.{tmux.conf,gitignore,gitconfig,gitattributes,bash_profile,aliases,bashrc,exports,vimrc,vim,customFunctions}; do
        if [ -f $file ]; then
            rm $file
        fi
    done
}
#2}}}

#Function: bashFiles() sets the bash dotfiles {{{2
function bashFiles() {
for file in {zshrc,bash_profile,bashrc,tmux.conf}; do
    if [ -f $HOME/.$file ]; then
        rm $HOME/.$file
    fi

    ln -s $DOTFILES_ROOT/$file $HOME/.$file
done
ln -s $DOTFILES_ROOT/"ghci.conf" $HOME/.ghc/"ghci.conf"
unset file
echo -e "All dotfiles up and running!\n"
}
#2}}}

#Function: vimFiles() sets .vimrc and .vim {{{2
function vimFiles() {
git submodule init; git submodule update
ln -s  $DOTFILES_ROOT/vim $HOME/.vim
ln -s $DOTFILES_ROOT/vim/vimrc $HOME/.vimrc
ln -s $DOTFILES_ROOT/xvimrc $HOME/.xvimrc
echo -e "Vim files and plugins up and running!\n"
cd $DOTFILES_ROOT
}
#2}}}

#Function: nvimFiles() sets .nvimrc and .nvim {{{2
function nvimFiles() {
if [ ! -d $HOME/.config ]; then
    mkdir -p $HOME/.config
fi
    ln -s  $DOTFILES_ROOT/nvim $HOME/.config/nvim
    ln -s $DOTFILES_ROOT/nvim/init.vim $HOME/.config/init.vim
cd $DOTFILES_ROOT
}
#2}}}
#Function: vimperator() sets vimperator options {{{2
function vimperator() {
if [ -d /Applications/Firefox.app ]; then
    ln -s "$DOTFILES_ROOT/vimperator" "$HOME/.vimperator"
    ln -s "$DOTFILES_ROOT/vimperator/vimperatorrc" "$HOME/.vimperatorrc"
fi
}

#Function: gitFiles() sets global git config dotfiles {{{2
function gitFiles() {
for file in {gitignore,gitconfig}; do
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
vimperator
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

