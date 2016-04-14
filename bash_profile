if [ -f ~/dotfiles/bashrc ]; then
       source ~/dotfiles/bashrc
fi

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
