#!/bin/bash

# Script to upload keyboard configuration to CH57x keyboard

set -e

CONFIG_FILE="keyboard_config.yaml"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "⌨️  CH57x Keyboard Configuration Upload"
echo "======================================="
echo ""

# Change to script directory
cd "$SCRIPT_DIR"

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Error: $CONFIG_FILE not found"
    echo "Expected location: $SCRIPT_DIR/$CONFIG_FILE"
    exit 1
fi

echo "✅ Found configuration file: $CONFIG_FILE"
echo ""

# Check if ch57x-keyboard-tool is installed
if ! command -v ch57x-keyboard-tool &> /dev/null; then
    echo "❌ Error: ch57x-keyboard-tool not found"
    echo ""
    echo "Please install it first:"
    echo "  ./install_ch57x_tool.sh"
    echo ""
    echo "Or add it to your PATH if already installed"
    exit 1
fi

echo "✅ ch57x-keyboard-tool found: $(which ch57x-keyboard-tool)"
echo ""

# Check if keyboard is connected
echo "🔍 Checking for keyboard..."
if ! bash ./check_keyboard_usb.sh > /dev/null 2>&1; then
    echo "❌ Error: CH57x keyboard not detected"
    echo ""
    echo "Please:"
    echo "  1. Connect your keyboard"
    echo "  2. Use a data-capable USB cable"
    echo "  3. Try a different USB port"
    echo ""
    exit 1
fi

echo "✅ Keyboard detected"
echo ""

# Backup existing config if it exists (optional)
if [ -f "keyboard_config_backup.yaml" ]; then
    echo "📦 Previous backup found, keeping it"
else
    echo "📦 Creating backup of current config"
    cp "$CONFIG_FILE" "keyboard_config_backup.yaml" 2>/dev/null || true
fi

echo ""
echo "🔍 Validating configuration..."
if ! cat "$CONFIG_FILE" | ch57x-keyboard-tool validate; then
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

# Upload configuration
# The tool reads from stdin, so we pipe the config file to it
# Need sudo for USB device access on macOS
cat "$CONFIG_FILE" | sudo ch57x-keyboard-tool upload

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
