#!/bin/bash

# Script to validate keyboard configuration without uploading

CONFIG_FILE="keyboard_config.yaml"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔍 Keyboard Configuration Validator"
echo "===================================="
echo ""

# Change to script directory
cd "$SCRIPT_DIR"

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Error: $CONFIG_FILE not found"
    echo "Expected location: $SCRIPT_DIR/$CONFIG_FILE"
    exit 1
fi

echo "📄 Validating: $CONFIG_FILE"
echo ""

# Check if ch57x-keyboard-tool is installed
if ! command -v ch57x-keyboard-tool &> /dev/null; then
    echo "❌ Error: ch57x-keyboard-tool not found"
    echo ""
    echo "Please install it first:"
    echo "  ./install_ch57x_tool.sh"
    exit 1
fi

# Validate configuration
if cat "$CONFIG_FILE" | ch57x-keyboard-tool validate; then
    echo ""
    echo "✅ Configuration is valid!"
    echo ""
    echo "You can now upload it with:"
    echo "  ./upload_config.sh"
    exit 0
else
    echo ""
    echo "❌ Configuration has errors"
    echo ""
    echo "Common issues:"
    echo "  - Incorrect key names (use 'ch57x-keyboard-tool show-keys')"
    echo "  - Wrong YAML syntax (check indentation)"
    echo "  - Invalid modifier combinations"
    echo ""
    echo "Fix the errors in $CONFIG_FILE and try again"
    exit 1
fi
