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

# --- stay on main ----------------------------------------------------------
if [[ "$1" == "--main" || "$1" == "-m" ]]; then
  cd "$SV_REPO"
  exec claude "${@:2}"
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

exec claude "${@:2}"
