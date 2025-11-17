#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title coding
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description coding workspace
# @raycast.author aesadde
# @raycast.authorURL https://raycast.com/aesadde

echo "Setting up workspace"

# Open the custom window layout using Raycast deeplink
open "raycast://customWindowManagementCommand?&name=dev"

# Toggle the focus session
open "raycast://focus/start?goal=Deep%20Focus&categories=social,gaming,programming&&mode=block"
