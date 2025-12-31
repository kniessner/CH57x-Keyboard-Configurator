#!/bin/bash

# Script to backup current keyboard configuration
# Note: ch57x-keyboard-tool doesn't support downloading config from device
# This script creates timestamped backups of your YAML config file

CONFIG_FILE="keyboard_config.yaml"
BACKUP_DIR="config_backups"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "💾 Keyboard Configuration Backup"
echo "================================="
echo ""

# Change to script directory
cd "$SCRIPT_DIR"

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Error: $CONFIG_FILE not found"
    exit 1
fi

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Generate timestamp for backup filename
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/keyboard_config_${TIMESTAMP}.yaml"

# Create backup
cp "$CONFIG_FILE" "$BACKUP_FILE"

echo "✅ Configuration backed up to:"
echo "   $BACKUP_FILE"
echo ""

# Show backup size and summary
echo "📊 Backup summary:"
echo "   Size: $(du -h "$BACKUP_FILE" | cut -f1)"
echo "   Location: $BACKUP_DIR/"
echo ""

# List recent backups
echo "📁 Recent backups:"
ls -lht "$BACKUP_DIR" | head -6

echo ""
echo "📝 Notes:"
echo "  - The keyboard stores config in onboard memory"
echo "  - ch57x-keyboard-tool cannot download config from device"
echo "  - These backups are of your local YAML files"
echo "  - Keep backups of working configurations!"
echo ""
echo "To restore a backup:"
echo "  cp $BACKUP_DIR/keyboard_config_YYYYMMDD_HHMMSS.yaml $CONFIG_FILE"
echo "  ./upload_config.sh"
