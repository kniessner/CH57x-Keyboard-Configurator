# Shell Command Bindings

Execute custom shell commands when specific keys or key combinations are pressed on your macro keyboard.

## Overview

The Shell Command feature allows you to bind any shell command to keyboard keys. When the listener is active and you press the configured key combination, the associated command will execute automatically.

## How It Works

1. **Configure Bindings**: Map key combinations to shell commands through the GUI
2. **Start Listener**: Activate the keyboard listener to monitor for your configured keys
3. **Press Keys**: When you press a bound key, the command executes automatically

## Setup Instructions

### 1. Install Dependencies

The shell command feature requires `pynput`:

```bash
./keyboard.sh gui
```

That command creates `venv/` if needed and installs the required Python packages, including `pynput`.

### 2. Configure Key Bindings

1. Open the GUI: `./keyboard.sh gui`
2. Scroll to the "Shell Command Bindings" section
3. Enter a key combination (e.g., `f13`, `cmd+f13`, `f14`)
4. Enter the shell command to execute (e.g., `open -a Calculator`)
5. Click "Add"

### 3. Start the Listener

Click the "Start Listener" button to activate keyboard monitoring. The status will show "Listener Active" with a green indicator.

## Key Combination Format

- **Single keys**: `f13`, `f14`, etc.
- **With modifiers**: Keys are detected as pressed together
- The system automatically normalizes key combinations

## Example Commands

### Open Applications
```bash
# Open Calculator
open -a Calculator

# Open Spotify
open -a Spotify

# Open Terminal
open -a Terminal
```

### System Commands
```bash
# Take a screenshot
screencapture -c

# Lock screen
pmset displaysleepnow

# Empty trash
osascript -e 'tell application "Finder" to empty trash'
```

### Custom Scripts
```bash
# Run a custom script
/Users/yourusername/scripts/my_script.sh

# Execute with parameters
/usr/local/bin/mycommand --flag value
```

### AppleScript Integration
```bash
# Control Spotify
osascript -e 'tell application "Spotify" to playpause'

# Show notification
osascript -e 'display notification "Hello!" with title "My Keyboard"'
```

## Storage

Command bindings are stored in `shell_commands.json` in the keyboard directory. This file is automatically created and maintained by the GUI.

## Security Considerations

⚠️ **Important**: Shell commands execute with your user permissions. Be careful about:

- Commands that modify or delete files
- Commands that access sensitive data
- Commands from untrusted sources
- Commands that run indefinitely

Always test commands in a terminal first before binding them to keys.

## Troubleshooting

### Listener Won't Start
- Refresh the local Python environment: `./keyboard.sh gui`
- Check for permission issues in System Preferences > Security & Privacy > Accessibility

### Commands Not Executing
- Verify the listener is active (green indicator)
- Test the command in Terminal first
- Check the console output for error messages
- Ensure the key combination doesn't conflict with system shortcuts

### macOS Permissions
On macOS, you may need to grant accessibility permissions:
1. System Preferences > Security & Privacy > Privacy > Accessibility
2. Add Python or your terminal application
3. Restart the GUI

## Workflow Integration

Combine shell commands with your keyboard configuration:

1. Configure macro keys (F13-F24) on your physical keyboard
2. Bind those keys to shell commands
3. Use the keyboard for instant access to applications and scripts
4. Create complex workflows with custom scripts

## Tips

- Use absolute paths for scripts and commands
- Test commands thoroughly before binding
- Document your bindings (what each key does)
- Create backup of `shell_commands.json`
- Use meaningful key combinations you'll remember
