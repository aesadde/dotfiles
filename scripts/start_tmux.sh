#!/bin/sh
export PATH=$PATH:/usr/local/bin

# abort if we're already inside a TMUX session
[ "$TMUX" == "" ] || exit 0

# startup a "main" session if none currently exists
if tmux has-session -t main; then
  tmux attach -t main
else
  tmux new-session -s main -d
  tmux rename-window -t main notes
  tmux send-keys -t main 'notes' C-m
  tmux attach -t main
fi
