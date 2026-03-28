#!/bin/bash

# Script to backup current keyboard configuration
# Note: ch57x-keyboard-tool doesn't support downloading config from device
# This script creates timestamped backups of your YAML config file

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/common.sh"

print_header "Keyboard Configuration Backup"
cd_project_root
require_file "$CONFIG_FILE"

BACKUP_FILE="$(create_timestamped_backup "$CONFIG_FILE")"

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
echo "  ./keyboard.sh upload"
