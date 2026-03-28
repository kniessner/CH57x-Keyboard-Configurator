# CH57x Macro Keyboard Setup

Complete setup and management for your CH57x macro keyboard (3 rows × 4 columns + 2 knobs) on macOS.

## 🚀 Quick Start

```bash
# Web GUI (recommended for easy configuration)
./run_gui.sh

# One-command manager
./manage.sh

# Or run individual scripts:
./check_keyboard_usb.sh    # Check connection
./validate_config.sh       # Validate config
./upload_config.sh         # Upload to keyboard
./setup_karabiner.sh       # Setup advanced mappings
```

## 🖥️ Web GUI Features

Run `./run_gui.sh` to launch the web-based configurator at `http://localhost:5001`

### Features:
- **Visual Keyboard Layout**: Configure all buttons and knobs visually
- **Configuration Presets**: Save and load multiple keyboard configurations
- **Shell Command Bindings**: Execute custom shell commands on key press
- **LED Control**: Configure backlight modes and colors
- **Key Logger**: Test and debug key presses in real-time
- **Auto-Upload**: Automatically upload changes to keyboard
- **Device Detection**: See connection status (USB/Bluetooth)

### Shell Commands ⚡
Bind shell commands to any key combination:
1. Open GUI and scroll to "Shell Command Bindings"
2. Enter key combo (e.g., `f13`) and shell command
3. Click "Start Listener" to activate
4. Press the key to execute the command

Examples:
- `open -a Calculator` - Open Calculator app
- `screencapture -c` - Take screenshot
- `/path/to/script.sh` - Run custom script

See [SHELL_COMMANDS.md](SHELL_COMMANDS.md) for detailed documentation.

## 📁 Files

| File | Purpose |
|------|---------|
| `run_gui.sh` | **Launch web-based configurator** |
| `keyboard_config_gui.py` | Web GUI application |
| `manage.sh` | **Interactive menu for all operations** |
| `keyboard_config.yaml` | Main keyboard configuration |
| `presets/` | Saved configuration presets |
| `shell_commands.json` | Shell command bindings |
| `keyboard_config_test.yaml` | Test config (buttons type numbers) |
| `karabiner_type_test.json` | Karabiner rules for typing "test" |
| `check_keyboard_usb.sh` | Verify keyboard connection |
| `validate_config.sh` | Validate config before upload |
| `upload_config.sh` | Upload config to keyboard (needs sudo) |
| `backup_config.sh` | Create timestamped backup |
| `test_buttons.sh` | Test button layout |
| `setup_karabiner.sh` | Install Karabiner configuration |
| `install_ch57x_tool.sh` | Install programming tool |

## 🎹 Current Button Layout

```
┌─────┬─────┬─────┬─────┐
│ F3  │  s  │  s  │ F16 │  ← Row 1
│     │     │     │test │
├─────┼─────┼─────┼─────┤
│ F18 │⌘⇧F │ ⌃`  │ ⌘A  │  ← Row 2
│test │     │     │     │
├─────┼─────┼─────┼─────┤
│ ⌘Z  │⌘⇧Z │⌘⇧4 │ F17 │  ← Row 3
└─────┴─────┴─────┴─────┘

🎚️ Knob 1: Volume ↻ / Mute ⏺
🎚️ Knob 2: Track ↻ / Play ⏺
```

**Buttons configured to type "test" (via Karabiner):**
- Row 1, Button 4 (F16)
- Row 2, Button 1 (F18)

## 🔧 Setup Steps

### 1. Check Keyboard

```bash
./check_keyboard_usb.sh
```

Should show: `✅ CH57x keyboard detected!`

### 2. Install Tool (First Time Only)

```bash
./install_ch57x_tool.sh
```

Choose cargo (option 1) or binary (option 2).

### 3. Edit Configuration

```bash
nano keyboard_config.yaml
```

Edit button mappings as needed.

### 4. Upload Configuration

```bash
./upload_config.sh
```

Will ask for your password (sudo required for USB access).

### 5. Setup Karabiner (For "test" typing)

```bash
./setup_karabiner.sh
```

Enable rules in Karabiner-Elements app.

## 📝 Configuration Syntax

### Basic Keys
```yaml
- ["a", "b", "c", "d"]          # Single keys
- ["f13", "f14", "f15", "f16"]  # Function keys
```

### With Modifiers
```yaml
- ["cmd-c", "cmd-v", "cmd-z"]           # Command + key
- ["cmd-shift-f", "ctrl-alt-delete"]    # Multiple modifiers
```

### Media Keys
```yaml
- ["volumeup", "volumedown", "mute"]
- ["play", "next", "previous"]
```

### Available Modifiers
- `cmd` (⌘), `ctrl` (⌃), `shift` (⇧), `alt` (⌥)
- `rcmd`, `rctrl`, `rshift`, `ralt` (right-side versions)

### Key Names
Run `ch57x-keyboard-tool show-keys` to see all available keys.

## 🧪 Testing Button Layout

To identify which physical button is which config position:

```bash
./test_buttons.sh
```

Each button will type its index number (1-9, 0, -, =).

## 🎯 Common Shortcuts

```yaml
# Development
- ["cmd-c", "cmd-v", "cmd-shift-f"]     # Copy, Paste, Format
- ["cmd-p", "cmd-shift-f", "ctrl-grave"] # Quick Open, Find, Terminal
- ["cmd-z", "cmd-shift-z", "cmd-s"]     # Undo, Redo, Save

# Navigation
- ["cmd-tab", "cmd-grave", "cmd-w"]     # Switch App/Window, Close
- ["cmd-t", "cmd-shift-t", "cmd-w"]     # New Tab, Reopen, Close

# Media
- ["volumeup", "volumedown", "mute"]
- ["play", "next", "previous"]
```

## 🔧 Troubleshooting

### Keyboard Not Detected
```bash
./check_keyboard_usb.sh
```
- Try different USB port
- Use data-capable cable
- Check USB-C adapter

### Upload Permission Error
- Normal on macOS - requires sudo
- Script will prompt for password
- This is safe and expected

### Keys Not Working
1. Unplug and replug keyboard
2. Validate config: `./validate_config.sh`
3. Check key names match available keys
4. Re-upload configuration

### Karabiner Not Triggering
1. System Settings → Privacy → Input Monitoring
2. Enable Karabiner-Elements
3. Check rules are enabled in app
4. Restart Karabiner-Elements

## 💡 Tips

1. **Start simple** - Test basic keys before complex shortcuts
2. **Use F13-F24** - No conflicts with system shortcuts
3. **Backup often** - Run `./backup_config.sh` before changes
4. **Test incrementally** - Upload and test one row at a time
5. **Document changes** - Add comments to YAML file

## 🎨 Advanced: Typing Custom Strings

The keyboard can only send single keystrokes. To type strings like "test":

1. **Map button to F-key** (e.g., F13, F16, F18)
2. **Use Karabiner** to convert F-key to keystroke sequence
3. **Enable rule** in Karabiner-Elements

See `karabiner_type_test.json` for example.

## 📦 Backup & Restore

### Create Backup
```bash
./backup_config.sh
```

Saves to `config_backups/keyboard_config_YYYYMMDD_HHMMSS.yaml`

### Restore Backup
```bash
cp config_backups/keyboard_config_YYYYMMDD_HHMMSS.yaml keyboard_config.yaml
./upload_config.sh
```

## 🔗 Resources

- [ch57x-keyboard-tool](https://github.com/kriomant/ch57x-keyboard-tool)
- [Karabiner-Elements](https://karabiner-elements.pqrs.org/)
- [USB HID Key Codes](https://www.usb.org/sites/default/files/documents/hut1_12v2.pdf)

---

**Need help? Run `./manage.sh` for interactive menu! 🎹**
