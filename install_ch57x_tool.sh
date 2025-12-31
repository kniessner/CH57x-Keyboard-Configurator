#!/bin/bash

# Installation script for ch57x-keyboard-tool on macOS

set -e

echo "🚀 CH57x Keyboard Tool Installation"
echo "===================================="
echo ""

# Check if Rust/Cargo is installed
if command -v cargo &> /dev/null; then
    echo "✅ Cargo detected"
    USE_CARGO=true
else
    echo "⚠️  Cargo not found"
    USE_CARGO=false
fi

# Prompt user for installation method
echo ""
echo "Installation options:"
echo "  1. Install via cargo (recommended - always gets latest version)"
echo "  2. Download pre-built binary"
echo ""

if [ "$USE_CARGO" = true ]; then
    read -p "Choose installation method (1 or 2) [1]: " choice
    choice=${choice:-1}
else
    echo "Cargo not available, will download binary"
    choice=2
fi

if [ "$choice" = "1" ]; then
    echo ""
    echo "📦 Installing ch57x-keyboard-tool via cargo..."
    cargo install ch57x-keyboard-tool

    echo ""
    echo "✅ Installation complete!"
    echo "Tool installed to: $(which ch57x-keyboard-tool)"

elif [ "$choice" = "2" ]; then
    echo ""
    echo "📦 Downloading pre-built binary..."

    # Create bin directory if it doesn't exist
    mkdir -p "$HOME/.local/bin"

    # Download latest release
    RELEASE_URL="https://github.com/kriomant/ch57x-keyboard-tool/releases/latest/download/ch57x-keyboard-tool-macos"

    echo "Downloading from: $RELEASE_URL"
    curl -L "$RELEASE_URL" -o "$HOME/.local/bin/ch57x-keyboard-tool"

    # Make executable
    chmod +x "$HOME/.local/bin/ch57x-keyboard-tool"

    echo ""
    echo "✅ Binary downloaded to: $HOME/.local/bin/ch57x-keyboard-tool"
    echo ""
    echo "⚠️  Make sure $HOME/.local/bin is in your PATH"
    echo "Add this to your ~/.zshrc or ~/.bash_profile:"
    echo '    export PATH="$HOME/.local/bin:$PATH"'
else
    echo "Invalid choice"
    exit 1
fi

echo ""
echo "🧪 Testing installation..."
ch57x-keyboard-tool --version || echo "⚠️  Tool not in PATH yet. Restart terminal or add to PATH."

echo ""
echo "✨ Next steps:"
echo "  1. Run: ./check_keyboard_usb.sh (to verify keyboard is connected)"
echo "  2. Edit: keyboard_config.yaml (customize your key mappings)"
echo "  3. Run: ./upload_config.sh (to upload configuration to keyboard)"
