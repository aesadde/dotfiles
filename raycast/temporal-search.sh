#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Search Temporal Community
# @raycast.mode silent
# @raycast.packageName Temporal Community

# Optional parameters:
# @raycast.argument1 { "type": "text", "placeholder": "Query", "optional": true}

# ref: https://gist.github.com/cdown/1163649
urlencode() {
    # urlencode <string>

    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C

    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:$i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf '%s' "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done

    LC_COLLATE=$old_lc_collate
}

first_argument=$(urlencode ${1// /+})

if [ "$1" = "" ]; then
	open "https://community.temporal.io"
else
	open "https://community.temporal.io/search?q=$first_argument"
fi
