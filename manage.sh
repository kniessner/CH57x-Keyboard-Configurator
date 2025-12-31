#!/bin/bash

# CH57x Keyboard Management Script
# One script to manage all common operations

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

show_menu() {
    echo ""
    echo "🎹 CH57x Keyboard Manager"
    echo "========================="
    echo ""
    echo "  1) Check keyboard connection"
    echo "  2) Validate configuration"
    echo "  3) Upload configuration to keyboard"
    echo "  4) Backup configuration"
    echo "  5) Test button layout (types numbers)"
    echo "  6) Setup Karabiner-Elements"
    echo "  7) Install ch57x-keyboard-tool"
    echo "  8) Show current config"
    echo "  9) Exit"
    echo ""
}

while true; do
    show_menu
    read -p "Select option (1-9): " choice
    echo ""

    case $choice in
        1)
            echo "🔍 Checking keyboard..."
            ./check_keyboard_usb.sh
            read -p "Press Enter to continue..."
            ;;
        2)
            echo "🔍 Validating configuration..."
            ./validate_config.sh
            read -p "Press Enter to continue..."
            ;;
        3)
            echo "📤 Uploading configuration..."
            ./upload_config.sh
            read -p "Press Enter to continue..."
            ;;
        4)
            echo "💾 Creating backup..."
            ./backup_config.sh
            read -p "Press Enter to continue..."
            ;;
        5)
            echo "🧪 Starting button test..."
            ./test_buttons.sh
            read -p "Press Enter to continue..."
            ;;
        6)
            echo "🎹 Setting up Karabiner..."
            ./setup_karabiner.sh
            read -p "Press Enter to continue..."
            ;;
        7)
            echo "📦 Installing ch57x-keyboard-tool..."
            ./install_ch57x_tool.sh
            read -p "Press Enter to continue..."
            ;;
        8)
            echo "📄 Current Configuration:"
            echo "========================="
            cat keyboard_config.yaml
            read -p "Press Enter to continue..."
            ;;
        9)
            echo "👋 Goodbye!"
            exit 0
            ;;
        *)
            echo "❌ Invalid option"
            sleep 1
            ;;
    esac
done
