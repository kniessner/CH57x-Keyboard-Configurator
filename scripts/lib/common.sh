#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CONFIG_FILE="${CONFIG_FILE:-keyboard_config.yaml}"
BACKUP_DIR="${BACKUP_DIR:-config_backups}"
CH57X_TOOL="${CH57X_TOOL:-ch57x-keyboard-tool}"

cd_project_root() {
    cd "$PROJECT_ROOT"
}

fail() {
    echo "❌ Error: $*" >&2
    exit 1
}

print_header() {
    local title="$1"
    echo "$title"
    printf '%*s\n' "${#title}" '' | tr ' ' '='
    echo ""
}

require_file() {
    local path="$1"
    [ -f "$path" ] || fail "$path not found"
}

ensure_ch57x_tool() {
    if ! command -v "$CH57X_TOOL" >/dev/null 2>&1; then
        fail "$CH57X_TOOL not found. Run ./keyboard.sh install first."
    fi
}

require_keyboard_connected() {
    if ! "$PROJECT_ROOT/scripts/check_keyboard_usb.sh" >/dev/null 2>&1; then
        fail "CH57x keyboard not detected. Check the USB cable and port, then retry."
    fi
}

validate_yaml_file() {
    local path="$1"
    cat "$path" | "$CH57X_TOOL" validate
}

upload_yaml_file() {
    local path="$1"
    cat "$path" | sudo "$CH57X_TOOL" upload
}

create_timestamped_backup() {
    local source_file="$1"
    mkdir -p "$BACKUP_DIR"

    local timestamp
    timestamp="$(date +"%Y%m%d_%H%M%S")"

    local backup_file="$BACKUP_DIR/${source_file%.yaml}_${timestamp}.yaml"
    cp "$source_file" "$backup_file"
    echo "$backup_file"
}

ensure_python_env() {
    cd_project_root

    if [ ! -d "venv" ]; then
        echo "Creating virtual environment..."
        python3 -m venv venv
    fi

    # shellcheck disable=SC1091
    source venv/bin/activate

    if ! python3 -c "import flask, yaml, pynput" >/dev/null 2>&1; then
        echo "Installing Python dependencies..."
        pip install -r requirements.txt
    fi
}
