#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title carefulwords
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "Placeholder" }
# @raycast.packageName Writing

# Documentation:
# @raycast.description Lookup a word in @simonsarris carefulwords.com
# @raycast.author aesadde
# @raycast.authorURL twitter.com/aesadde

if ! [[ $# == 1 ]]; then
  echo "need at least one argument"
  exit 1
fi

# uppercase word to avoid redirects
word=$1
word="$(tr '[:lower:]' '[:upper:]' <<< "${word:0:1}")${word:1}"

curl -s https://carefulwords.com/"$word"
