#!/bin/sh

# error out if tmux not avilable
type tmux > /dev/null || (echo "Please install tmux"; exit 1)
# abort if we're already inside a TMUX session
[ "$TMUX" == "" ] || exit 0

DOW=$(date +%u) # Day of the week
HOUR=$(date +%X | cut -d : -f 1)

start_session() {
  SESSION=$1
  if tmux has-session -t $SESSION 2> /dev/null; then
    tmux attach -t $SESSION
  else
    tmux new-session -s $SESSION -d
    tmux rename-window -t $SESSION tasks
    tmux send-keys -t $SESSION "cd ~/Projects && cat TODO.md" C-m
    tmux split-window -h
    tmux attach -t $SESSION
  fi
}

monitor_session() {
  SESSION='monitor'
  if tmux has-session -t $SESSION 2> /dev/null; then
    tmux attach -t $SESSION
  else
    tmux new-session -s $SESSION -d
    tmux rename-window -t $SESSION usage
    tmux split-window -h
    tmux send-keys -t $SESSION "(which htop && htop) || (which top && top)" C-m
    tmux split-window -v
    tmux send-keys "(which gpustat && gpustat) || (which nvidia-smi && nvidia-smi -L)" C-m
    tmux select-pane -t 0
    tmux attach -t $SESSION
  fi
}


# Give options
PS4="Please choose your session: "
options=($(tmux list-sessions -F "#S" 2> /dev/null) "NEW SESSION" "default" "monitor")

echo "Available sessions"
echo "------------------"
select opt in "${options[@]}"
do
  case $opt in
    "NEW SESSION")
      read -p "Enter new session name: " SESSION_NAME
      tmux new -s "$SESSION_NAME"
      break ;;
    "default")
      start_session 'default'
      break ;;
    "monitor")
      monitor_session
      break ;;
    *)
      tmux attach-session -t $opt
      break ;;
  esac
done
