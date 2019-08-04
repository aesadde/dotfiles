#!/bin/sh

# error out if tmux not avilable
type tmux > /dev/null || (echo "Please install tmux"; exit 1)
# abort if we're already inside a TMUX session
[ "$TMUX" == "" ] || exit 0

DOW=$(date +%u) # Day of the week
HOUR=$(date +%X | cut -d : -f 1)

tasks_window() {
  tmux rename-window -t $SESSION tasks
  tmux send-keys -t $SESSION "cd ~/Projects && tasks" C-m
  tmux split-window -h
}

akorda_session() {
  kubectl config use-context "$1-cluster"
  tmux new-session -s $SESSION -d
  tasks_window
  tmux new-window -t $SESSION
  tmux rename-window -t $SESSION connections
  tmux send-keys -t $SESSION "kproxy $1" C-m
  tmux split-window -v
  tmux send-keys -t $SESSION "dbproxy $1" C-m
  tmux previous-window -t $SESSION
}

start_session() {
  SESSION=$1
  if tmux has-session -t $SESSION 2> /dev/null; then
    :
  elif [ "$SESSION" == "akorda-dev" ]; then
    akorda_session "dev"
  elif [ "$SESSION" == "akorda-qa" ]; then
    akorda_session "qa"
  else
    tmux new-session -s $SESSION -d
    tasks_window
  fi

  tmux attach -t $SESSION
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
options=($(tmux list-sessions -F "#S" 2> /dev/null) "NEW SESSION" "akorda-dev" "akorda-qa" "default" "monitor")

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
    "akorda-dev")
      start_session 'akorda-dev'
      break ;;
    "akorda-qa")
      start_session 'akorda-qa'
      break ;;
    "monitor")
      monitor_session
      break ;;
    *)
      tmux attach-session -t $opt
      break ;;
  esac
done
