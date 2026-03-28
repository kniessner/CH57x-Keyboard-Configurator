#!/bin/bash
# Launcher script for CH57x Keyboard Configuration GUI

cd "$(dirname "$0")"

ensure_venv() {
    if [ ! -d "venv" ]; then
        echo "Creating virtual environment..."
        python3 -m venv venv
    fi

    source venv/bin/activate

    if ! python3 -c "import flask, yaml, pynput" >/dev/null 2>&1; then
        echo "Installing Python dependencies..."
        pip install -r requirements.txt
    fi
}

ensure_venv

# Run the GUI
python3 keyboard_config_gui.py
