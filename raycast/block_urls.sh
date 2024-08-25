#!/bin/bash
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Block URLs
# @raycast.mode silent
# @raycast.packageName Productivity

# Optional parameters:
# @raycast.icon 🧘

# Documentation:
# @raycast.description Blocks a list of given URLs
#
# Needs to run as root. Modify and run this command to store the password in the
# Keychain:
# security add-generic-password -s 'toggle_block_urls_script' -a 'your_username' -w 'your_password' -T /usr/bin/security


# Define file paths
URL_FILE="urls_to_block.txt"
HOSTS_FILE="/etc/hosts"
TEMP_FILE=$(mktemp)

# Keychain item details
KEYCHAIN_ITEM='toggle_block_urls_script'
KEYCHAIN_ACCOUNT='aesadde' # Replace with your actual username

# Retrieve the password from the keychain
if ! sudo_password=$(security find-generic-password -w -s "$KEYCHAIN_ITEM" -a "$KEYCHAIN_ACCOUNT"); then
  echo "Could not get password from keychain, error $?"
  exit 1
fi

# Check if run as root using the sudo password
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  echo "$sudo_password" | sudo -S /Users/aesadde/dotfiles/raycast/block_urls.sh
  exit 1
fi

# Read urls_to_block.txt and process each line
while IFS= read -r line; do
  # Toggle blocking status
  if grep -q "127.0.0.1 $line" "$HOSTS_FILE"; then
    # URL is currently blocked, so unblock it
    grep -v "127.0.0.1 $line" "$HOSTS_FILE" > "$TEMP_FILE"
    mv "$TEMP_FILE" "$HOSTS_FILE"
    echo "Unblocked $line"
  else
    # URL is not blocked, so block it
    echo "127.0.0.1 $line" >> "$HOSTS_FILE"
    echo "Blocked $line"
  fi
done < "$URL_FILE"

# Clean up temporary file
rm -f "$TEMP_FILE"

