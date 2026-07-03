#!/bin/bash

# cw — create a Supervisible git worktree and launch Claude inside it.
#
# Default behaviour: ALWAYS land on a fresh worktree.
#
# Usage:
#   cw sv-512-fix-auth     Create worktree off main, branch sv-512-fix-auth, launch claude
#   cw sv-512              Same, slug auto-suffixed if you pass just the id
#   cw                     New scratch worktree (scratch-MMDD-HHMM) — never main by accident
#   cw --main | -m         Stay on the main repo checkout, just launch claude
#   cw --no-id <slug>      Accepted for backwards compatibility (now a no-op)
#
# Branch is created off main. If the branch already exists, its worktree is reused.
# When run inside tmux, the current window is renamed to the slug.

set -e

SV_REPO="${SV_REPO:-$HOME/repos/supervisible}"
SV_WT="${SV_WT:-$HOME/repos/sv-worktree}"

# --- resolve the claude CLI robustly --------------------------------------
# `cw` is a shell alias, so this bash script runs as a child process: it can't
# see zsh aliases/functions and may inherit a stale PATH or command hash (e.g.
# right after reinstalling claude). Resolve an absolute path up front, falling
# back to known install locations, so we never die with a cryptic
# "exec: claude: not found" — and bail before touching worktrees if it's gone.
CLAUDE_BIN="$(command -v claude 2>/dev/null || true)"
if [[ -z "$CLAUDE_BIN" ]]; then
  for c in \
    /opt/homebrew/bin/claude \
    /usr/local/bin/claude \
    "$HOME/.local/bin/claude" \
    "$HOME/.claude/local/claude"; do
    if [[ -x "$c" ]]; then CLAUDE_BIN="$c"; break; fi
  done
fi
if [[ -z "$CLAUDE_BIN" ]]; then
  echo "cw: could not find the 'claude' CLI on PATH or in known locations." >&2
  echo "cw: is Claude Code installed? try:  which claude  (in a fresh shell)" >&2
  exit 127
fi

# --- stay on main ----------------------------------------------------------
if [[ "$1" == "--main" || "$1" == "-m" ]]; then
  cd "$SV_REPO"
  exec "$CLAUDE_BIN" "${@:2}"
fi

# --- parse flags -----------------------------------------------------------
# --no-id used to relax the linear-id requirement; that requirement is gone,
# so the flag is now accepted but ignored.
if [[ "$1" == "--no-id" ]]; then
  shift
fi

# normalize to lowercase so 'SV-502' == 'sv-502'
slug="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"

# --- default to a scratch worktree when no slug given ----------------------
if [[ -z "$slug" ]]; then
  slug="scratch-$(date +%m%d-%H%M)"
fi

branch="$slug"
dir="$SV_WT/$slug"

# --- create (or reuse) the worktree ---------------------------------------
git -C "$SV_REPO" worktree prune

if [[ -d "$dir" ]]; then
  echo "cw: reusing existing worktree at $dir"
elif git -C "$SV_REPO" show-ref --verify --quiet "refs/heads/$branch"; then
  echo "cw: branch '$branch' exists — checking it out in a new worktree"
  git -C "$SV_REPO" worktree add "$dir" "$branch"
else
  echo "cw: creating worktree '$branch' off main"
  git -C "$SV_REPO" worktree add -b "$branch" "$dir" main
fi

cd "$dir"

# --- name the tmux window after the slug -----------------------------------
if [[ -n "$TMUX" ]]; then
  tmux rename-window "$slug" >/dev/null 2>&1
fi

exec "$CLAUDE_BIN" "${@:2}"
