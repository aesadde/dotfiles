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

# Create necessary directories if they don't exist
mkdir -p "$BACKUP_BASE/home/backup-$DATE"
mkdir -p "$BACKUP_BASE/home/backup-$DATE/icloud"
mkdir -p "$BACKUP_BASE/photos/backup-$DATE"

# Backup home directory
rsync -avz \
  --delete \
  --ignore-errors \
  --link-dest="$BACKUP_BASE/home/$LATEST" \
  --exclude-from="$HOME/dotfiles/scripts/exclude-list.txt" \
  --log-file="$HOME/dotfiles/scripts/backup_details.log" \
  "$SOURCE/" \
  "$BACKUP_BASE/home/backup-$DATE/"

# Backup iCloud folder to a specific location
rsync -avz \
  --delete \
  --ignore-errors \
  --link-dest="$BACKUP_BASE/home/$LATEST/icloud" \
  --exclude-from="$HOME/dotfiles/scripts/exclude-list.txt" \
  --log-file="$HOME/dotfiles/scripts/backup_details.log" \
  "$ICLOUD_SOURCE/" \
  "$BACKUP_BASE/home/backup-$DATE/icloud/"

# Backup Photos Library
echo "Backing up Photos Library..."
rsync -avz \
  --delete \
  --ignore-errors \
  --link-dest="$BACKUP_BASE/photos/latest" \
  --log-file="$HOME/dotfiles/scripts/backup_details.log" \
  "$PHOTOS_SOURCE/" \
  "$BACKUP_BASE/photos/backup-$DATE/"

# Update the "latest" symbolic links
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
