#!/bin/sh

# error out if tmux not avilable
type tmux > /dev/null || (echo "Please install tmux"; exit 1)
# abort if we're already inside a TMUX session
[ "$TMUX" == "" ] || exit 0

DOW=$(date +%u) # Day of the week
HOUR=$(date +%X | cut -d : -f 1)

tasks_window() {
  tmux rename-window -t $SESSION tasks
  tmux send-keys -t $SESSION "nvim -c VimwikiDiaryIndex" C-m
}

dev() {
  kubectl config use-context "dev"
  tmux new-session -s $SESSION -d
  tmux new-window -t $SESSION
  tmux rename-window -t $SESSION connections
  tmux send-keys -t $SESSION "kproxy" C-m
  tmux split-window -v
  tmux send-keys -t $SESSION "kubectl -n dev port-forward svc/cloudsql-proxy 3306:3306" C-m
  tmux split-window -v
  tmux send-keys -t $SESSION "kubectl -n qa port-forward svc/cloudsql-proxy 3307:3306" C-m
  tmux split-window -h
  tmux send-keys -t $SESSION "kubectl -n dev port-forward elasticsearch-master-0 9200:9200" C-m
  tmux split-window -h
  tmux send-keys -t $SESSION "kubectl -n qa port-forward elasticsearch-master-0 9300:9200" C-m
  tmux new-window -t $SESSION
}

prod() {
  kubectl config use-context "prod"
  tmux new-session -s $SESSION -d
  tmux new-window -t $SESSION
  tmux rename-window -t $SESSION connections
  tmux send-keys -t $SESSION "kproxy" C-m
  tmux split-window -v
  tmux send-keys -t $SESSION "kubectl port-forward svc/cloudsql-proxy 3306:3306" C-m
  tmux split-window -h
  tmux send-keys -t $SESSION "kubectl port-forward elasticsearch-master-0 9200:9200" C-m
  tmux new-window -t $SESSION
}

start_session() {
  SESSION=$1
  if tmux has-session -t $SESSION 2> /dev/null; then
    tmux attach -t $SESSION
  elif [ "$SESSION" == "dev" ]; then
    dev
  elif [ "$SESSION" == "prod" ]; then
    prod
  else
    tmux new-session -s $SESSION -d
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
options=($(tmux list-sessions -F "#S" 2> /dev/null) "NEW SESSION" "dev" "prod" "default" "monitor")

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
    "dev")
      start_session 'dev'
      break ;;
    "prod")
      start_session 'prod'
      break ;;
    "monitor")
      monitor_session
      break ;;
    *)
      tmux attach-session -t $opt
      break ;;
  esac
done
