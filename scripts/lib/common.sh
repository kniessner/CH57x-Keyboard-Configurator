#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CONFIG_FILE="${CONFIG_FILE:-keyboard_config.yaml}"
BACKUP_DIR="${BACKUP_DIR:-config_backups}"
CH57X_TOOL="${CH57X_TOOL:-ch57x-keyboard-tool}"

resolve_project_path() {
    local path="$1"
    case "$path" in
        /*) printf '%s\n' "$path" ;;
        *) printf '%s\n' "$PROJECT_ROOT/$path" ;;
    esac
}

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
    local resolved_path
    resolved_path="$(resolve_project_path "$path")"
    [ -f "$resolved_path" ] || fail "$path not found"
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
    local resolved_source_file
    local resolved_backup_dir
    resolved_source_file="$(resolve_project_path "$source_file")"
    resolved_backup_dir="$(resolve_project_path "$BACKUP_DIR")"

    mkdir -p "$resolved_backup_dir"

    local timestamp
    timestamp="$(date +"%Y%m%d_%H%M%S")"

    local source_name
    source_name="$(basename "$source_file")"
    local backup_file="$resolved_backup_dir/${source_name%.yaml}_${timestamp}.yaml"

    cp "$resolved_source_file" "$backup_file"
    echo "$backup_file"
}

ensure_python_env() {
    local venv_dir
    local requirements_file
    venv_dir="$(resolve_project_path "venv")"
    requirements_file="$(resolve_project_path "requirements.txt")"

    if [ ! -d "$venv_dir" ]; then
        echo "Creating virtual environment..."
        python3 -m venv "$venv_dir"
    fi

    # shellcheck disable=SC1091
    source "$venv_dir/bin/activate"

    if ! python3 -c "import flask, yaml, pynput" >/dev/null 2>&1; then
        echo "Installing Python dependencies..."
        pip install -r "$requirements_file"
    fi
}
