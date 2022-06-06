#!/usr/bin/env bash

# Dependency: Goland (https://www.jetbrains.com/go/)

# @raycast.title Open with Goland
# @raycast.author Alberto Sadde
# @raycast.authorURL https://github.com/aesadde
# @raycast.description Search for emojis related to input.

# @raycast.icon 🖥
# @raycast.mode silent
# @raycast.packageName System
# @raycast.schemaVersion 1

# @raycast.argument1 { "type": "text", "placeholder": "project name" }
# @raycast.argument2 { "type": "text", "optional": true, "placeholder": "Base Dir..."  }
# @raycast.argument3 { "type": "text", "optional": true, "placeholder": "IDE..."  }

# goland is installed in this path, raycast doesn't allow login shells
export PATH=$PATH:/Users/aesadde/.local/bin

if [ -z "$1" ]; then
  echo "First arg can't be blank"
  exit 1
fi
GLOB="*$1*"

BASE_DIR="/Users/aesadde/repos"
if [ -n "$2" ]; then
  BASE_DIR="$2"
fi

IDE="goland"
if [ -n "$3" ]; then
  IDE="$3"
fi

if ! command -v goland &>/dev/null; then
  echo "goland command is required (https://www.jetbrains.com/go/)."
  exit 1
fi

if ! command -v fd &>/dev/null; then
  echo "fd is required (install with brew install fd)"
  exit 1
fi

repo=$(fd --maxdepth 2 --type d --glob "$GLOB" "$BASE_DIR")

if [ -z "$repo" ]; then
  echo "No repo found."
  exit 1
fi

$IDE "$repo"
