#!/bin/sh
export PATH=$PATH:/usr/local/bin

#Change this for a different local session
LOCAL_SESSION=$HOME/dotfiles/scripts/aifi.sh

# abort if we're already inside a TMUX session
[ "$TMUX" == "" ] || exit 0

# startup a "default" session if none currently exists
tmux has-session -t _default || tmux new-session -s _default -d

# present menu for user to choose which workspace to open
PS3="Please choose your session: "
options=($(tmux list-sessions -F "#S") "NEW SESSION" "aifi" "ZSH")
echo "Available sessions"
echo "------------------"
echo " "
select opt in "${options[@]}"
do
    case $opt in
        "NEW SESSION")
            read -p "Enter new session name: " SESSION_NAME
            tmux new -s "$SESSION_NAME"
            break ;;
        "ZSH")
            zsh --login
            break
						;;
        "aifi")
           if [ -f $LOCAL_SESSION ]; then
             bash $LOCAL_SESSION
           fi
					 break
					 ;;
        *)
            tmux attach-session -t $opt
            break
            ;;
    esac
done
