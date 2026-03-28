#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/common.sh"

print_header "CH57x Keyboard Toolkit TUI"
ensure_python_env

python3 keyboard_config_tui.py
