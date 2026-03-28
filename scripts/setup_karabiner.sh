#!/bin/bash

# Install Karabiner-Elements configuration for CH57x keyboard

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
KARABINER_CONFIG_DIR="$HOME/.config/karabiner/assets/complex_modifications"
CONFIG_FILE="$PROJECT_ROOT/karabiner_type_test.json"

echo "🎹 Karabiner-Elements Setup"
echo "==========================="
echo ""

# Check if Karabiner-Elements is installed
if [ ! -d "/Applications/Karabiner-Elements.app" ]; then
    echo "⚠️  Karabiner-Elements not installed"
    echo ""
    echo "Install via Homebrew? (y/N): "
    read -p "" install_kb

    if [[ "$install_kb" =~ ^[Yy]$ ]]; then
        echo ""
        echo "Installing Karabiner-Elements..."
        brew install --cask karabiner-elements
        echo ""
        echo "✅ Installed! Please grant permissions in System Settings, then run this script again."
        exit 0
    else
        echo ""
        echo "Install manually from: https://karabiner-elements.pqrs.org/"
        exit 1
    fi
fi

echo "✅ Karabiner-Elements found"
echo ""

# Create config directory
mkdir -p "$KARABINER_CONFIG_DIR"

# Copy configuration
echo "📦 Installing configuration..."
cp "$CONFIG_FILE" "$KARABINER_CONFIG_DIR/ch57x_type_test.json"

echo "✅ Configuration installed"
echo ""

echo "📋 Next steps:"
echo "  1. Open Karabiner-Elements"
echo "  2. Go to 'Complex Modifications' tab"
echo "  3. Click 'Add rule'"
echo "  4. Enable these rules:"
echo "     • F13 (Row 1, Button 1) → Type 'test'"
echo "     • F16 (Row 1, Button 4) → Type 'test'"
echo "     • F18 (Row 2, Button 1) → Type 'test'"
echo ""

read -p "Open Karabiner-Elements now? (y/N): " open_kb
if [[ "$open_kb" =~ ^[Yy]$ ]]; then
    open -a "Karabiner-Elements"
fi
