#!/bin/bash

# Script to upload keyboard configuration to CH57x keyboard

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/common.sh"

print_header "CH57x Keyboard Configuration Upload"
cd_project_root
require_file "$CONFIG_FILE"
ensure_ch57x_tool

echo "✅ Found configuration file: $CONFIG_FILE"
echo ""
echo "✅ ch57x-keyboard-tool found: $(command -v "$CH57X_TOOL")"
echo ""

# Check if keyboard is connected
echo "🔍 Checking for keyboard..."
require_keyboard_connected

echo "✅ Keyboard detected"
echo ""

echo "📦 Creating timestamped backup of current config"
backup_file="$(create_timestamped_backup "$CONFIG_FILE")"
echo "   $backup_file"

echo ""
echo "🔍 Validating configuration..."
if ! validate_yaml_file "$CONFIG_FILE"; then
    echo ""
    echo "❌ Configuration validation failed!"
    echo "Please check your $CONFIG_FILE for errors"
    exit 1
fi

echo "✅ Configuration is valid"
echo ""
echo "🚀 Uploading to keyboard..."
echo "⚠️  USB access requires elevated permissions (sudo)"
echo "You'll be prompted for your password."
echo ""

upload_yaml_file "$CONFIG_FILE"

echo ""
echo "✅ Configuration uploaded successfully!"
echo ""
echo "Your keyboard has been programmed. The configuration is"
echo "stored in onboard memory and will work on any computer."
echo ""
echo "📝 Tips:"
echo "  - Test each key to verify mappings"
echo "  - Edit $CONFIG_FILE and re-run this script to update"
echo "  - Use Karabiner-Elements for advanced F13-F24 mappings"
echo ""
echo "🔄 If keys don't work as expected:"
echo "  1. Unplug and replug the keyboard"
echo "  2. Check the config file for syntax errors"
echo "  3. Run 'ch57x-keyboard-tool --help' for more options"
