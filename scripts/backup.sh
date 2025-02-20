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

# Check if backup drive is mounted
if [ ! -d "$BACKUP_BASE" ]; then
    echo "Error: Backup destination $BACKUP_BASE is not available"
    exit 1
fi

# Check available space
available_space=$(df -k "$BACKUP_BASE" | tail -1 | awk '{print $4}')
minimum_space=$((50 * 1024 * 1024)) # 50GB in KB

if [ "$available_space" -lt "$minimum_space" ]; then
    echo "Error: Insufficient space on backup drive (less than 50GB available)"
    exit 1
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
            --ignore-errors \
            --link-dest="$link_dest" \
            --exclude-from="$HOME/dotfiles/scripts/exclude-list.txt" \
            --log-file="$HOME/dotfiles/scripts/backup_details.log" \
            "$source/" \
            "$dest/" && return 0
        
        echo "Rsync failed. Waiting 30 seconds before retry..."
        sleep 30
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
du -sh "$BACKUP_BASE/home"
echo "Photos backups:"
du -sh "$BACKUP_BASE/photos"

# List remaining backups
echo "Remaining home backups:"
ls -lh "$BACKUP_BASE/home" | grep "backup-"
echo "Remaining photos backups:"
ls -lh "$BACKUP_BASE/photos" | grep "backup-"
