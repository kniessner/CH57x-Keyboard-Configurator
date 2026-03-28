# Available Keys in GUI

The GUI now **dynamically fetches all available keys** from `ch57x-keyboard-tool show-keys` command, ensuring you always have access to the latest supported keys.

## Summary

- **📊 Total Keys:** 112 keyboard keys
- **🎵 Media Keys:** 10 media control keys
- **🖱️ Mouse Actions:** 4 mouse action types
- **⌨️ Modifiers:** 8 modifier keys

## Key Categories

### 🔤 Regular Keys (112 total)
All standard keyboard keys including:
- **Letters:** a-z
- **Numbers:** 0-9
- **Function keys:** f1-f24
- **Navigation:** arrow keys, home, end, pageup, pagedown
- **Editing:** enter, escape, backspace, tab, space, delete
- **Symbols:** minus, equal, leftbracket, rightbracket, backslash, semicolon, quote, grave, comma, dot, slash
- **Numpad:** numpad0-9, numpadslash, numpadasterisk, numpadminus, numpadplus, numpadenter, numpaddot, numpadequal
- **Special:** capslock, numlock, printscreen, insert, application, power, nonushash, nonusbackslash
- **Mac-specific:** macbrightnessup, macbrightnessdown

### 🎵 Media Keys (10 total)
- `next` - Next track
- `previous` - Previous track
- `stop` - Stop playback
- `play` - Play/Pause
- `mute` - Toggle mute
- `volumeup` - Increase volume
- `volumedown` - Decrease volume
- `favorites` - Open favorites
- `calculator` - Open calculator
- `screenlock` - Lock screen

### 🖱️ Mouse Actions (4 examples)
- `wheel(-100)` - Mouse wheel scroll (negative = down, positive = up)
- `click(left+right)` - Mouse click combinations
- `move(5,0)` - Move mouse cursor (x,y pixels)
- `drag(left+right,0,5)` - Drag operations with mouse buttons

**Note:** Mouse actions support parameters - modify the numbers to customize behavior!

### ⌨️ Modifiers (8 total)
- `ctrl` - Left Control
- `shift` - Left Shift
- `alt` - Left Alt/Option
- `win` - Left Windows/Command
- `rctrl` - Right Control
- `rshift` - Right Shift
- `ralt` - Right Alt/Option
- `rwin` - Right Windows/Command

## Key Combinations

Combine modifiers with keys using hyphens:
- `cmd-c` - Copy
- `ctrl-shift-tab` - Previous tab
- `cmd-shift-rightbracket` - Next browser tab
- `alt-f4` - Close window

## Usage in GUI

### Button Configuration
1. Click any button field in the layout
2. Start typing to see autocomplete suggestions
3. Select from:
   - All 112 keyboard keys
   - 10 media control keys
   - 4 mouse action templates
   - Pre-defined common shortcuts

### Knob Configuration
1. Use preset buttons for quick setup
2. Or manually enter any:
   - Media keys (volumeup, next, play, etc.)
   - Key combinations (ctrl-tab, cmd-w, etc.)
   - Mouse actions with custom parameters

### Autocomplete
The GUI provides **intelligent autocomplete** with:
- ✅ All keys from `ch57x-keyboard-tool show-keys`
- ✅ Media keys labeled as "(Media)"
- ✅ Mouse actions labeled as "(Mouse)"
- ✅ Common shortcuts with descriptions

## Dynamic Updates

The key list is fetched **every time the GUI loads**, so:
- ✅ Always up-to-date with your tool version
- ✅ Automatically includes new keys from tool updates
- ✅ No manual updates needed

## Custom Key Syntax

For advanced users, the tool also supports:
- **Custom key codes:** `<110>` (use decimal USB HID code)
- **Mouse wheel custom values:** `wheel(-50)`, `wheel(100)`
- **Mouse movement custom values:** `move(10,20)`, `move(-5,0)`
- **Click combinations:** `click(left)`, `click(middle+right)`

## Testing

**Open the GUI:** http://localhost:5001

Try typing in any button field to see all available options with autocomplete!
