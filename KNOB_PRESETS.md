# Knob Configuration Presets

The GUI includes quick preset buttons for common knob configurations.

## Available Presets

### 🔊 Volume Control
- **Clockwise (CW):** `volumeup` - Increase volume
- **Counter-Clockwise (CCW):** `volumedown` - Decrease volume
- **Press:** `mute` - Toggle mute

### 🎵 Media Control
- **Clockwise (CW):** `next` - Next track
- **Counter-Clockwise (CCW):** `previous` - Previous track
- **Press:** `play` - Play/Pause

### 🌐 Browser Tabs
- **Clockwise (CW):** `ctrl-tab` - Next tab (Ctrl+Tab)
- **Counter-Clockwise (CCW):** `ctrl-shift-tab` - Previous tab (Ctrl+Shift+Tab)
- **Press:** `cmd-w` - Close current tab (⌘+W)

**Works in all major browsers:** Chrome, Firefox, Safari, Edge, Arc, Brave

**Alternative shortcuts available:**
- `cmd-shift-rightbracket` - Next tab (⌘+⇧+])
- `cmd-shift-leftbracket` - Previous tab (⌘+⇧+[)
- `cmd-t` - New tab (⌘+T)

### 🔍 Zoom Control ✨ NEW
- **Clockwise (CW):** `cmd-equal` - Zoom in (⌘+=)
- **Counter-Clockwise (CCW):** `cmd-minus` - Zoom out (⌘+-)
- **Press:** `cmd-0` - Reset zoom to 100% (⌘+0)

**Works in:** All browsers, PDF readers, most applications

### ☀️ Brightness Control
- **Clockwise (CW):** `macbrightnessup` - Increase brightness
- **Counter-Clockwise (CCW):** `macbrightnessdown` - Decrease brightness
- **Press:** `mute` - Toggle mute

### 📜 Page Scroll ✨ NEW
- **Clockwise (CW):** `wheel(3)` - Scroll down
- **Counter-Clockwise (CCW):** `wheel(-3)` - Scroll up
- **Press:** `cmd-w` - Close window/tab (⌘+W)

**Works in:** All applications, web browsers, documents, PDFs

**How it works:**
- The `wheel()` command simulates mouse wheel scrolling
- Positive values scroll down, negative values scroll up
- The number controls scroll speed (3 is a comfortable speed)
- Perfect for reading documents or browsing without touching the mouse

**Scroll speed customization:**
- `wheel(1)` - Slow, precise scrolling
- `wheel(3)` - Default, comfortable speed
- `wheel(5)` - Fast scrolling
- `wheel(10)` - Very fast scrolling

## How to Use

1. Open the GUI at http://localhost:5001
2. Scroll to the "Knob Configuration" section
3. Click a preset button (e.g., "🌐 Browser Tabs") for the knob you want to configure
4. The fields will auto-fill with the preset values
5. You can manually edit any field if needed
6. Click "💾 Save Configuration" and it will auto-upload if enabled

## Custom Configuration

You can also manually enter any valid key combination:
- Simple keys: `a`, `b`, `1`, `2`
- Modifiers: `cmd-`, `ctrl-`, `shift-`, `alt-`, `opt-`
- Combinations: `cmd-shift-rightbracket`, `ctrl-alt-delete`
- Media keys: `volumeup`, `volumedown`, `next`, `previous`, `play`, `mute`
- Mac keys: `macbrightnessup`, `macbrightnessdown`

## Preset Tips

### Browser Tab Navigation
The `ctrl-tab` and `ctrl-shift-tab` shortcuts work universally across:
- ✅ Chrome, Firefox, Safari, Edge, Arc, Brave
- ✅ VS Code, Terminal, and most tabbed applications

Alternative: `cmd-shift-rightbracket` / `cmd-shift-leftbracket` (macOS browser standard)

### Zoom Control
The zoom preset (`cmd-equal`, `cmd-minus`, `cmd-0`) works in:
- ✅ All web browsers
- ✅ PDF readers (Preview, Adobe Acrobat)
- ✅ Text editors (VS Code, Sublime)
- ✅ Most macOS applications

**Note:** `cmd-equal` is the same as `cmd-plus` (⌘+=) since + is on the = key.
