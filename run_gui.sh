#!/bin/bash
# Launcher script for CH57x Keyboard Configuration GUI

cd "$(dirname "$0")"

# Check if venv exists
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    source venv/bin/activate
    pip install flask pyyaml
else
    source venv/bin/activate
fi

# Run the GUI
python3 keyboard_config_gui.py
