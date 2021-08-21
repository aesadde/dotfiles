#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Decode URL
# @raycast.mode silent
# @raycast.packageName Developer Utilities

# Optional parameters:
# @raycast.icon 💻

# Documentation:
# @raycast.description Encodes clipboard content to URL and copies it again.

pbpaste | python -c "import urllib;print urllib.unquote(raw_input())" | pbcopy
echo "Clipboard URL Encoded"
