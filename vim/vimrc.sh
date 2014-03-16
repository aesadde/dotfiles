#!/bin/bash

    echo "initialising all submodules"
    git submodule init
    git submodule update
    echo "Create symbolic link to the actual vimrc inside .vim"
    echo $PWD
    echo $HOME
    ln -s $PWD/vimrc $HOME/.vimrc  
    ln -s $PWD $HOME/.vim
