#!/bin/bash

# Dependency: Goland (https://www.jetbrains.com/go/)

# @raycast.title Open with Goland
# @raycast.author Alberto Sadde
# @raycast.authorURL https://github.com/aesadde
# @raycast.description Search for emojis related to input.

# @raycast.icon 🖥
# @raycast.mode silent
# @raycast.packageName System
# @raycast.schemaVersion 1

# @raycast.argument1 { "type": "text", "placeholder": "Directory..." }

if ! command -v goland &> /dev/null; then
	echo "goland command is required (https://www.jetbrains.com/go/).";
	exit 1;
fi

goland "/Users/aesadde/repos/akorda/${1}"
