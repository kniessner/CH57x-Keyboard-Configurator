#!/bin/bash
# Launcher script for CH57x Keyboard Configuration GUI

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/common.sh"

print_header "CH57x Keyboard Configuration GUI"
ensure_python_env

# Run the GUI
python3 keyboard_config_gui.py
