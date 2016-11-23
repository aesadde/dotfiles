#!/usr/bin/env bash
#===============================================================================
#          FILE: setup.sh
#         USAGE: ./setup.sh
#
#   DESCRIPTION: Setup dotfiles
#
#       OPTIONS: -h usage
#  REQUIREMENTS: bash, vim 7+, nvim 0.1+
#          BUGS:
#         NOTES:
#        AUTHOR: Alberto Sadde
#       CREATED: 03/15/2014 20:35
#       VERSION: 0.2
#===============================================================================

#Variables: {{{1
DOTFILES_ROOT=$PWD
#}}}
#Functions: All functions are declared here {{{1
#Function: usage() prints the usage instructions {{{2
function usage() {
  echo -e "Need to select at least one option\n"
  echo -e "-h for help\n-all for all dotfiles\n-vim just for vim dotfiles\n-bash
  just for bash dotfiles\n-git for git dotfiles\n-clean to remove old dotfiles"

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
    -shell)
      shellFiles
      ;;
    -git)
      gitFiles
      ;;
    -jobs)
      installJobs
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
  for file in $HOME/.{scripts,tmux.conf,gitignore,gitconfig,gitattributes,bash_profile,aliases,bashrc,exports,init.vim,customFunctions}; do
    if [ -f $file ]; then
      rm $file
    fi
  done
  unset file

  if [ -d $HOME/.config ]; then
    rm -rf $HOME/.config
  fi
}
#2}}}
#Function: shellFiles() sets the shell dotfiles {{{2
function shellFiles() {
  for file in {ghci.conf,zshrc,bash_profile,bashrc,tmux.conf}; do
    if [ -f $HOME/.$file ]; then
      rm $HOME/.$file
    fi

    ln -s $DOTFILES_ROOT/$file $HOME/.$file
  done
  unset file

  if [ ! -f $HOME/.scripts ]; then
    ln -s $DOTFILES_ROOT/scripts $HOME/.scripts
  fi

  echo -e "All shell dotfiles up and running!\n"
}
#2}}}
#Function: vimFiles() sets .vimrc and .vim {{{2
function vimFiles() {
  git submodule init; git submodule update
  ln -s  $DOTFILES_ROOT/vim $HOME/.vim
  ln -s $DOTFILES_ROOT/vim/vimrc $HOME/.vimrc
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
#Function: installJobs() installs all jobs in jobs dir {{{2
function installJobs() {
  LAUNCH=/Library/LaunchAgents
  cd $DOTFILES_ROOT/jobs
  for file in *; do
    /usr/bin/sudo cp $file $LAUNCH/.
    /usr/bin/sudo chown root:wheel $LAUNCH/$file
    sudo launchctl load $LAUNCH/$file
  done
  cd $DOTFILES_ROOT
}
#2}}}
#Function: all() sets all dotfiles {{{2
function all() {
  shellFiles
  vimperator
  vimFiles
  gitFiles
  installJobs
}
#2}}}
#Main: {{{
# check we are given at least one parameter
[[ $# -ne 1 ]] && usage
parseOptions $1
#}}}
