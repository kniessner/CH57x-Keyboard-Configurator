# Keyboard Layers Guide

Your CH57x keyboard supports **multiple layers** - different sets of key mappings that you can switch between using a physical button on the keyboard.

## What Are Layers?

Think of layers like different "pages" of key configurations. Each layer has its own complete set of button and knob mappings.

**Example Use Cases:**
- **Layer 1:** Function keys (F13-F24) for default shortcuts
- **Layer 2:** Letters and navigation for typing mode
- **Layer 3:** Shortcuts and macros for specific apps (Photoshop, VS Code, etc.)

## Your Keyboard's Layer System

### Physical Layer Button
Your keyboard has a **dedicated layer button on the side** that cycles through layers:
- Press once → Layer 2
- Press again → Layer 3
- Press again → Layer 1 (back to start)

### LED Indicators
When you press the layer button, the keyboard briefly displays the current layer number using LEDs on top.

## How Many Layers?

Most CH57x keyboards support **3 layers**, though some variants may differ.

## Configuration Format

Each layer is defined in the YAML config file:

```yaml
orientation: normal
rows: 3
columns: 4
knobs: 2
layers:
  # Layer 1 - Function Keys
  - buttons:
      - [f13, f14, f15, f16]
      - [f17, f18, f19, f20]
      - [f21, f22, f23, f24]
    knobs:
      - {cw: volumeup, ccw: volumedown, press: mute}
      - {cw: next, ccw: previous, press: play}

  # Layer 2 - Typing/Letters
  - buttons:
      - [a, b, c, d]
      - [e, f, g, h]
      - [i, j, k, l]
    knobs:
      - {cw: macbrightnessup, ccw: macbrightnessdown, press: mute}
      - {cw: up, ccw: down, press: enter}

  # Layer 3 - Shortcuts
  - buttons:
      - [cmd-c, cmd-v, cmd-x, cmd-z]
      - [cmd-a, cmd-s, cmd-f, cmd-w]
      - [cmd-t, cmd-n, cmd-q, escape]
    knobs:
      - {cw: ctrl-tab, ccw: ctrl-shift-tab, press: cmd-w}
      - {cw: cmd-equal, ccw: cmd-minus, press: cmd-0}
```

## Layer Ideas & Examples

### Layer 1: Default / Function Keys
**Purpose:** Universal function keys that work everywhere
```yaml
- buttons:
    - [f13, f14, f15, f16]
    - [f17, f18, f19, f20]
    - [f21, f22, f23, f24]
  knobs:
    - {cw: volumeup, ccw: volumedown, press: mute}
    - {cw: next, ccw: previous, press: play}
```

**Use with:** Karabiner-Elements to map F13-F24 to complex actions

### Layer 2: Developer Tools
**Purpose:** Common development shortcuts
```yaml
- buttons:
    - [cmd-p, cmd-shift-f, ctrl-grave, cmd-b]        # Go to File, Search, Terminal, Build
    - [f5, shift-f5, cmd-shift-d, cmd-shift-k]       # Run, Stop, Debug, Terminal Kill
    - [cmd-/, cmd-shift-p, cmd-k-cmd-s, cmd-,]       # Comment, Command Palette, Shortcuts, Settings
  knobs:
    - {cw: ctrl-tab, ccw: ctrl-shift-tab, press: cmd-w}     # Tab navigation
    - {cw: cmd-equal, ccw: cmd-minus, press: cmd-0}         # Zoom
```

### Layer 3: Photo/Video Editing
**Purpose:** Creative app shortcuts
```yaml
- buttons:
    - [cmd-z, cmd-shift-z, cmd-j, cmd-t]           # Undo, Redo, Duplicate, Transform
    - [b, v, e, cmd-shift-c]                       # Brush, Move, Eraser, Copy Merged
    - [cmd-option-i, cmd-shift-u, cmd-u, escape]   # Inverse, Hue/Sat, Levels, Cancel
  knobs:
    - {cw: rightbracket, ccw: leftbracket, press: x}         # Brush size, swap colors
    - {cw: cmd-z, ccw: cmd-shift-z, press: cmd-0}            # Undo/Redo, Fit screen
```

### Layer 4: Browser Navigation (if supported)
**Purpose:** Web browsing shortcuts
```yaml
- buttons:
    - [cmd-l, cmd-shift-t, cmd-r, cmd-shift-r]     # Address bar, Reopen tab, Refresh, Hard refresh
    - [cmd-1, cmd-2, cmd-3, cmd-4]                 # Tab 1-4 shortcuts
    - [cmd-left, cmd-right, cmd-shift-delete, f11] # Back, Forward, Clear history, Fullscreen
  knobs:
    - {cw: ctrl-tab, ccw: ctrl-shift-tab, press: cmd-w}
    - {cw: cmd-equal, ccw: cmd-minus, press: cmd-0}
```

## Current Limitation

⚠️ **Note:** The GUI currently only supports editing **Layer 1**.

## Manual Layer Configuration

To configure multiple layers manually:

1. **Edit** `keyboard_config.yaml` in a text editor
2. **Copy** the existing layer block
3. **Paste** it below the first layer (maintaining indentation)
4. **Modify** the button and knob mappings for the new layer
5. **Save** the file
6. **Upload** using the GUI's upload button

Example structure:
```yaml
layers:
  - buttons:  # Layer 1
      # ...
  - buttons:  # Layer 2
      # ...
  - buttons:  # Layer 3
      # ...
```

## Testing Layers

1. Upload your multi-layer config to the keyboard
2. Press the physical layer button on the side of your keyboard
3. Watch the LED indicators show the current layer
4. Test the keys to verify each layer's mappings

## Tips

✅ **Keep Layer 1 universal** - Use function keys or shortcuts that work everywhere

✅ **Theme layers by purpose** - Dedicate each layer to a specific workflow or app

✅ **Use similar knob functions** - Keep volume/media on the same knobs across layers for muscle memory

✅ **Document your layers** - Add comments in the YAML file to remember what each layer does

✅ **Test thoroughly** - Upload and test each layer before finalizing

## Future GUI Support

🚧 **Coming Soon:** The GUI will be updated to support:
- Viewing and editing all layers
- Layer tabs or dropdown selector
- Copy/paste layers
- Quick layer templates

For now, manual YAML editing is required for multi-layer configurations.
