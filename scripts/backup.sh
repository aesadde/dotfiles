#!/bin/bash

# Exit on error
set -e

# Base directories
SOURCE="$HOME"
ICLOUD_SOURCE="/Users/aesadde/Library/Mobile Documents/com~apple~CloudDocs/main"
BACKUP_BASE="/Volumes/Lares/backups/aesadde"
PHOTOS_SOURCE="/Users/aesadde/Pictures/Photos Library.photoslibrary"
DATE=$(date +%Y-%m-%d)
LATEST="latest"
RETENTION_DAYS=30
BUFFER_SPACE=$((100 * 1024 * 1024)) # 100GB buffer in KB

# Check if backup drive is mounted
if [ ! -d "$BACKUP_BASE" ]; then
  echo "Error: Backup destination $BACKUP_BASE is not available"
  exit 1
fi

# Function to get available space in KB
get_available_space() {
  df -k "$BACKUP_BASE" | tail -1 | awk '{print $4}'
}

# Function to estimate backup size
estimate_backup_size() {
  local source=$1
  # Get size in KB, excluding files that would be excluded by rsync
  if [ -f "$HOME/dotfiles/scripts/exclude-list.txt" ]; then
    # Use rsync dry-run to get accurate size estimation with exclusions
    rsync -avz --dry-run --stats \
      --exclude-from="$HOME/dotfiles/scripts/exclude-list.txt" \
      "$source/" /tmp/rsync-dry-run-dummy 2>/dev/null | \
      grep "Total file size:" | \
      awk '{print int($4/1024)}' || du -sk "$source" | awk '{print $1}'
  else
    du -sk "$source" | awk '{print $1}'
  fi
}

# Check available space
available_space=$(get_available_space)
minimum_space=$((50 * 1024 * 1024)) # 50GB in KB

# Function to clean old backups until we have enough space
clean_old_backups() {
  local needed_space=$1
  echo "Cleaning old backups to free up space..."

  # List backups by date, oldest first (using sort instead of tail -r for compatibility)
  find "$BACKUP_BASE" -type d -name "backup-*" -print0 |
    xargs -0 ls -td |
    tac |
    while read backup; do
      echo "Removing old backup: $backup"
      rm -rf "$backup"

      # Check if we have enough space now
      available_space=$(get_available_space)
      if [ "$available_space" -gt "$needed_space" ]; then
        echo "Sufficient space freed ($(( available_space / 1024 / 1024 ))GB available)"
        return 0
      fi
    done
}

# Estimate total backup size needed
echo "Estimating backup size..."
home_size=$(estimate_backup_size "$SOURCE")
icloud_size=$(estimate_backup_size "$ICLOUD_SOURCE")
photos_size=$(estimate_backup_size "$PHOTOS_SOURCE")
total_size=$((home_size + icloud_size + photos_size + BUFFER_SPACE))

echo "Estimated backup size: $(( total_size / 1024 / 1024 ))GB"
echo "Available space: $(( available_space / 1024 / 1024 ))GB"

# Check space and clean if necessary
if [ "$available_space" -lt "$total_size" ]; then
  echo "Warning: Not enough space for backup (need $(( total_size / 1024 / 1024 ))GB, have $(( available_space / 1024 / 1024 ))GB)"
  clean_old_backups "$total_size"

  # Check space again
  available_space=$(get_available_space)
  if [ "$available_space" -lt "$total_size" ]; then
    echo "Error: Could not free enough space on backup drive"
    echo "Need: $(( total_size / 1024 / 1024 ))GB, Available: $(( available_space / 1024 / 1024 ))GB"
    exit 1
  fi
fi

# Create necessary directories if they don't exist
mkdir -p "$BACKUP_BASE/home/backup-$DATE"
mkdir -p "$BACKUP_BASE/home/backup-$DATE/icloud"
mkdir -p "$BACKUP_BASE/photos/backup-$DATE"

# Function to perform rsync with retry
perform_rsync() {
  local max_attempts=3
  local attempt=1
  local source=$1
  local dest=$2
  local link_dest=$3

  while [ $attempt -le $max_attempts ]; do
    echo "Attempt $attempt of $max_attempts for backing up $source"
    rsync -avz \
      --delete \
      --force \
      --partial \
      --partial-dir="$BACKUP_BASE/partial" \
      --link-dest="$link_dest" \
      --exclude-from="$HOME/dotfiles/scripts/exclude-list.txt" \
      --log-file="$HOME/dotfiles/scripts/backup_details.log" \
      --progress \
      "$source/" \
      "$dest/" && return 0

    # Check if failure was due to space
    if grep -q "No space left on device" "$HOME/dotfiles/scripts/backup_details.log" 2>/dev/null; then
      echo "Failed due to low space. Attempting to clean old backups..."
      available_space=$(get_available_space)
      # Try to free up at least 50GB more than current available
      needed_space=$((available_space + (50 * 1024 * 1024)))
      clean_old_backups "$needed_space"
    else
      echo "Rsync failed. Waiting 30 seconds before retry..."
      sleep 30
    fi
    ((attempt++))
  done

  echo "Failed to backup $source after $max_attempts attempts"
  return 1
}

# Backup home directory
echo "Backing up home directory..."
perform_rsync "$SOURCE" "$BACKUP_BASE/home/backup-$DATE" "$BACKUP_BASE/home/$LATEST" || exit 1

# Backup iCloud folder
echo "Backing up iCloud folder..."
perform_rsync "$ICLOUD_SOURCE" "$BACKUP_BASE/home/backup-$DATE/icloud" "$BACKUP_BASE/home/$LATEST/icloud" || exit 1

# Backup Photos Library
echo "Backing up Photos Library..."
perform_rsync "$PHOTOS_SOURCE" "$BACKUP_BASE/photos/backup-$DATE" "$BACKUP_BASE/photos/$LATEST" || exit 1

# Only update symbolic links if all backups succeeded
cd "$BACKUP_BASE/home" && ln -snf "backup-$DATE" latest
cd "$BACKUP_BASE/photos" && ln -snf "backup-$DATE" latest

# Clean up old backups (older than 30 days)
echo "Cleaning up backups older than $RETENTION_DAYS days..."
find "$BACKUP_BASE/home" -maxdepth 1 -name "backup-*" -type d -mtime +$RETENTION_DAYS -exec rm -rf {} \;
find "$BACKUP_BASE/photos" -maxdepth 1 -name "backup-*" -type d -mtime +$RETENTION_DAYS -exec rm -rf {} \;

# Print disk usage information
echo "Current backup disk usage:"
echo "Home backups:"
du -sh "$BACKUP_BASE/home" 2>/dev/null || echo "No home backups found"
echo "Photos backups:"
du -sh "$BACKUP_BASE/photos" 2>/dev/null || echo "No photos backups found"

# Show available space
echo "Available space on backup drive: $(( $(get_available_space) / 1024 / 1024 ))GB"

# List remaining backups
echo "Remaining home backups:"
ls -lh "$BACKUP_BASE/home" 2>/dev/null | grep "backup-" || echo "No home backups found"
echo "Remaining photos backups:"
ls -lh "$BACKUP_BASE/photos" 2>/dev/null | grep "backup-" || echo "No photos backups found"
