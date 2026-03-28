# Layer Switching Options

## The Limitation

The CH57x keyboard firmware **does not support programmatic layer switching** through button mappings. The `ch57x-keyboard-tool` doesn't expose any layer switching commands (like `layer1`, `layer2`, `layer3`) that can be assigned to buttons.

**Why?** Layer switching is handled entirely by the keyboard's firmware through the physical layer button on the side of the keyboard. This is a firmware-level limitation, not a software limitation.

## What You Can Do

### Option 1: Use the Physical Layer Button (Built-in)

Your keyboard already supports 3 layers switched via the physical button:

```
Press button once  → Layer 2
Press button twice → Layer 3
Press button again → Layer 1 (back to start)
```

**Pros:**
- Works immediately
- No configuration needed
- Hardware-level, very reliable
- LED indicators show current layer

**Cons:**
- Button is on the side (not on main grid)
- Requires reaching for the button

### Option 2: Quick-Switch Configuration Profiles (Recommended Workaround)

Instead of hardware layers, use **software profiles** that you can quickly switch between:

#### How It Works:
1. Save different complete keyboard configurations as "profiles"
2. Map buttons to F13-F16 (first row)
3. Use Karabiner-Elements to trigger profile uploads when F13-F16 are pressed
4. Each button = different keyboard layout

#### Setup:

1. **Create Profile Configurations:**
   ```bash
   # I've already created keyboard_profiles.yaml with 4 profiles:
   # - Developer: VS Code shortcuts
   # - Media: Music and video control
   # - Productivity: Copy/paste, window management
   # - Custom: Your current layout
   ```

2. **Create Upload Script:**
   ```bash
   #!/bin/bash
   # switch_profile.sh <profile_name>
   PROFILE=$1
   python3 -c "
   import yaml
   with open('keyboard_profiles.yaml') as f:
       profiles = yaml.safe_load(f)
   config = {
       'orientation': profiles['base']['orientation'],
       'rows': profiles['base']['rows'],
       'columns': profiles['base']['columns'],
       'knobs': profiles['base']['knobs'],
       'layers': profiles['profiles'][$PROFILE]['layers']
   }
   with open('keyboard_config.yaml', 'w') as f:
       yaml.dump(config, f)
   "
   sudo ch57x-keyboard-tool upload < keyboard_config.yaml
   ```

3. **Map F13-F16 to Profiles via Karabiner:**
   ```json
   {
     "description": "F13 → Developer Profile",
     "manipulators": [{
       "from": {"key_code": "f13"},
       "to": [{"shell_command": "./switch_profile.sh developer"}],
       "type": "basic"
     }]
   }
   ```

**Pros:**
- Buttons on the main keyboard grid
- Can have 4+ different complete layouts
- Customizable per your workflow
- Visual feedback when switching

**Cons:**
- Requires Karabiner-Elements setup
- Takes 1-2 seconds to upload new config
- Needs sudo password (or passwordless sudo setup)

### Option 3: Use All 3 Hardware Layers Effectively

Instead of trying to add more layers, **optimize the 3 layers you have**:

**Layer 1 (Default):**
- Row 1: F13, F14, F15, F16 (for Karabiner complex mappings)
- Row 2: Most-used shortcuts
- Row 3: Navigation or media

**Layer 2 (Press button once):**
- Development-specific shortcuts
- IDE commands
- Terminal shortcuts

**Layer 3 (Press button twice):**
- Media controls
- System commands
- Less frequently used shortcuts

**Pros:**
- No additional software needed
- Hardware-level reliability
- Fast switching (just press button)

**Cons:**
- Only 3 layers available
- Need to remember layer button location

## Recommended Solution

**For most users:** Use **Option 3** (optimize the 3 hardware layers)

**Why?**
- No extra software or scripts needed
- Most reliable (hardware-level)
- Fast switching
- 36 total button mappings (12 per layer) is usually enough

**For power users:** Combine **Option 1 + Option 2**
- Use hardware layers for quick access (3 × 12 buttons = 36 mappings)
- Use profile switching for completely different workflows
- Example: Hardware Layer 1 for work, Layer 2 for creative apps, Layer 3 for media
  Plus F13-F16 to switch between "Work Mode" and "Gaming Mode" configs entirely

## Example: Optimal 3-Layer Setup

```yaml
layers:
  # Layer 1: Universal - works everywhere
  - buttons:
      - [f13, f14, f15, f16]              # For Karabiner complex actions
      - [cmd-c, cmd-v, cmd-x, cmd-z]      # Essential editing
      - [left, right, up, down]           # Navigation
    knobs:
      - {cw: volumeup, ccw: volumedown, press: mute}
      - {cw: next, ccw: previous, press: play}

  # Layer 2: Development (press button once)
  - buttons:
      - [cmd-p, cmd-shift-f, ctrl-grave, cmd-b]
      - [f5, cmd-shift-k, cmd-shift-d, cmd-shift-p]
      - [cmd-/, cmd-k-cmd-s, cmd-,, escape]
    knobs:
      - {cw: ctrl-tab, ccw: ctrl-shift-tab, press: cmd-w}
      - {cw: cmd-equal, ccw: cmd-minus, press: cmd-0}

  # Layer 3: Media (press button twice)
  - buttons:
      - [play, stop, previous, next]
      - [volumeup, volumedown, mute, favorites]
      - [macbrightnessup, macbrightnessdown, cmd-q, cmd-w]
    knobs:
      - {cw: volumeup, ccw: volumedown, press: mute}
      - {cw: next, ccw: previous, press: play}
```

## Implementation Status

- ❌ **Button-based layer switching** - Not supported by firmware
- ✅ **Physical layer button** - Works out of the box
- ✅ **3 hardware layers** - Fully supported
- 🚧 **Profile switching** - Requires Karabiner + script setup
- ✅ **Example 3-layer config** - Available in `keyboard_config_3layers_example.yaml`

## Next Steps

1. **Try the 3-layer example:**
   ```bash
   cp keyboard_config_3layers_example.yaml keyboard_config.yaml
   sudo ch57x-keyboard-tool upload < keyboard_config.yaml
   ```

2. **Test the physical layer button:**
   - Find the button on the side of your keyboard
   - Press it to cycle through layers
   - Watch the LED indicators

3. **Customize for your workflow:**
   - Edit `keyboard_config.yaml`
   - Assign shortcuts you actually use
   - Upload and test each layer

## Future Possibilities

If the keyboard firmware is updated to support button-based layer switching, the tool would likely expose commands like:
- `layer1` or `<layer:1>`
- `layer2` or `<layer:2>`
- `layer3` or `<layer:3>`

These would then be assignable to any button. However, there's no indication this is planned or possible with the current firmware.

---

**Bottom line:** Use the 3 hardware layers effectively. It's simpler, more reliable, and sufficient for most workflows.
