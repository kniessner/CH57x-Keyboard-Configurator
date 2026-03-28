#!/bin/bash

# Setup passwordless sudo for ch57x-keyboard-tool
# This allows the GUI to upload configs without prompting for password

set -e

echo "⚙️  Setting up passwordless sudo for ch57x-keyboard-tool"
echo "========================================================="
echo ""

# Find the ch57x-keyboard-tool path
TOOL_PATH=$(which ch57x-keyboard-tool 2>/dev/null)

if [ -z "$TOOL_PATH" ]; then
    echo "❌ Error: ch57x-keyboard-tool not found in PATH"
    echo "Please install it first, then run this script again"
    exit 1
fi

echo "✅ Found tool at: $TOOL_PATH"
echo ""

# Get current username
USERNAME=$(whoami)

# Create sudoers rule
SUDOERS_RULE="$USERNAME ALL=(ALL) NOPASSWD: $TOOL_PATH"
SUDOERS_FILE="/etc/sudoers.d/ch57x-keyboard-tool"

echo "📝 Creating sudoers rule:"
echo "   $SUDOERS_RULE"
echo ""
echo "⚠️  This will allow '$USERNAME' to run ch57x-keyboard-tool with sudo"
echo "   without entering a password."
echo ""
read -p "Continue? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 1
fi

# Create the sudoers file with proper permissions
echo "$SUDOERS_RULE" | sudo tee "$SUDOERS_FILE" > /dev/null

# Set proper permissions (must be 0440 or 0400)
sudo chmod 0440 "$SUDOERS_FILE"

# Validate the sudoers file
if sudo visudo -c -f "$SUDOERS_FILE"; then
    echo ""
    echo "✅ Sudoers rule created successfully!"
    echo ""
    echo "📂 Rule location: $SUDOERS_FILE"
    echo ""
    echo "🧪 Testing passwordless sudo..."
    echo ""

    # Test it (validate command doesn't need keyboard connected)
    if echo "test" | sudo ch57x-keyboard-tool validate 2>&1 | grep -q "Error: load mapping config"; then
        echo "✅ Passwordless sudo is working!"
        echo ""
        echo "You can now upload keyboard configs without entering a password."
        echo "The GUI will work seamlessly."
    else
        echo "⚠️  Could not fully test, but rule is in place."
    fi
else
    echo ""
    echo "❌ Error: Sudoers validation failed"
    echo "Removing invalid rule..."
    sudo rm -f "$SUDOERS_FILE"
    exit 1
fi

echo ""
echo "🔒 Security note:"
echo "   Only the ch57x-keyboard-tool command can be run without password."
echo "   All other sudo commands will still require authentication."
echo ""
echo "🗑️  To remove this rule later, run:"
echo "   sudo rm $SUDOERS_FILE"
echo ""
