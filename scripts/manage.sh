#!/bin/bash

# CH57x Keyboard Management Script
# Primary entrypoint for common operations.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/common.sh"
cd_project_root

show_menu() {
    echo ""
    echo "🎹 CH57x Keyboard Manager"
    echo "========================="
    echo ""
    echo "Usage: ./keyboard.sh <command>"
    echo ""
    echo "Commands:"
    echo "  check       Check keyboard connection"
    echo "  validate    Validate configuration"
    echo "  upload      Upload configuration"
    echo "  backup      Create timestamped backup"
    echo "  test        Upload temporary button test layout"
    echo "  karabiner   Install Karabiner example rules"
    echo "  passwordless Configure passwordless uploads"
    echo "  install     Install ch57x-keyboard-tool"
    echo "  show        Print current config"
    echo "  tui         Run the terminal UI"
    echo "  gui         Run the local web UI"
    echo "  gui-start   Start GUI in background"
    echo "  gui-stop    Stop background GUI"
    echo "  gui-status  Show GUI status"
    echo "  gui-restart Restart background GUI"
    echo "  menu        Open the interactive menu"
    echo "  help        Show this help"
    echo ""
}

run_command() {
    case "${1:-help}" in
        check) "$SCRIPT_DIR/check_keyboard_usb.sh" ;;
        validate) "$SCRIPT_DIR/validate_config.sh" ;;
        upload) "$SCRIPT_DIR/upload_config.sh" ;;
        backup) "$SCRIPT_DIR/backup_config.sh" ;;
        test) "$SCRIPT_DIR/test_buttons.sh" ;;
        karabiner) "$SCRIPT_DIR/setup_karabiner.sh" ;;
        passwordless) "$SCRIPT_DIR/setup_passwordless_upload.sh" ;;
        install) "$SCRIPT_DIR/install_ch57x_tool.sh" ;;
        show) cat "$CONFIG_FILE" ;;
        tui) "$SCRIPT_DIR/run_tui.sh" ;;
        gui) "$SCRIPT_DIR/run_gui.sh" ;;
        gui-start) "$SCRIPT_DIR/gui_control.sh" start ;;
        gui-stop) "$SCRIPT_DIR/gui_control.sh" stop ;;
        gui-status) "$SCRIPT_DIR/gui_control.sh" status ;;
        gui-restart) "$SCRIPT_DIR/gui_control.sh" restart ;;
        help) show_menu ;;
        *)
            echo "❌ Unknown command: $1"
            echo ""
            show_menu
            exit 1
            ;;
    esac
}

interactive_menu() {
    while true; do
        echo ""
        echo "🎹 CH57x Keyboard Manager"
        echo "========================="
        echo ""
        echo "  1) Check keyboard connection"
        echo "  2) Validate configuration"
        echo "  3) Upload configuration to keyboard"
        echo "  4) Backup configuration"
        echo "  5) Test button layout"
        echo "  6) Setup Karabiner-Elements"
        echo "  7) Configure passwordless uploads"
        echo "  8) Install ch57x-keyboard-tool"
        echo "  9) Launch TUI"
        echo "  a) Launch GUI"
        echo "  b) Show current config"
        echo "  0) Exit"
        echo ""
        read -r -p "Select option (0-9, a-b): " choice
        echo ""

        case "$choice" in
            1) run_command check ;;
            2) run_command validate ;;
            3) run_command upload ;;
            4) run_command backup ;;
            5) run_command test ;;
            6) run_command karabiner ;;
            7) run_command passwordless ;;
            8) run_command install ;;
            9) run_command tui ;;
            a|A) run_command gui ;;
            b|B) run_command show ;;
            0) exit 0 ;;
            *) echo "❌ Invalid option" ;;
        esac

        echo ""
        read -r -p "Press Enter to continue..."
    done
}

case "${1:-help}" in
    menu)
        interactive_menu
        ;;
    *)
        run_command "${1:-help}"
        ;;
esac
