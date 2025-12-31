# Quick Layer Setup Guide

## What Are Layers?

Your keyboard has **3 layers** - like having 3 different keyboards in one! Switch between them using the **physical layer button** on the side of your keyboard.

```
┌─────────────────────────────────────┐
│  Layer 1: Function Keys (F13-F24)  │  ← Default layer
├─────────────────────────────────────┤
│  Layer 2: Developer Tools          │  ← Press layer button once
├─────────────────────────────────────┤
│  Layer 3: Productivity Shortcuts   │  ← Press layer button twice
└─────────────────────────────────────┘
         ↑ Press layer button again to cycle back to Layer 1
```

## How to Switch Layers

1. **Find the layer button** on the side of your keyboard (small button, usually labeled)
2. **Press it once** - LEDs briefly flash to show Layer 2
3. **Press again** - LEDs flash to show Layer 3
4. **Press again** - Back to Layer 1

## Example 3-Layer Setup

### 📄 Layer 1: Function Keys (Always Available)
```
┌──────┬──────┬──────┬──────┐
│  F13 │ F14  │ F15  │ F16  │
├──────┼──────┼──────┼──────┤
│  F17 │ F18  │ F19  │ F20  │
├──────┼──────┼──────┼──────┤
│  F21 │ F22  │ F23  │ F24  │
└──────┴──────┴──────┴──────┘

Knob 1: Volume Up/Down, Mute
Knob 2: Next/Prev Track, Play
```

### 💻 Layer 2: Developer Tools (Press layer button once)
```
┌─────────┬────────────┬──────────┬──────────┐
│ Go File │ Search All │ Terminal │  Build   │
│ (⌘P)    │ (⌘⇧F)      │ (^`)     │ (⌘B)     │
├─────────┼────────────┼──────────┼──────────┤
│   Run   │ Kill Term  │  Debug   │ Commands │
│ (F5)    │ (⌘⇧K)      │ (⌘⇧D)    │ (⌘⇧P)    │
├─────────┼────────────┼──────────┼──────────┤
│ Comment │  Format    │ Shortcuts│ Settings │
│ (⌘/)    │ (⌘⇧F)      │(⌘K ⌘S)   │ (⌘,)     │
└─────────┴────────────┴──────────┴──────────┘

Knob 1: Switch Tabs, Close Tab
Knob 2: Zoom In/Out, Reset
```

### ⚡ Layer 3: Productivity (Press layer button twice)
```
┌──────┬───────┬──────┬────────┐
│ Copy │ Paste │ Cut  │  Undo  │
│ (⌘C) │ (⌘V)  │ (⌘X) │  (⌘Z)  │
├──────┼───────┼──────┼────────┤
│ Sel. │ Save  │ Find │  Redo  │
│ All  │ (⌘S)  │ (⌘F) │ (⌘⇧Z)  │
├──────┼───────┼──────┼────────┤
│ New  │ Close │ Quit │ Screen │
│ Tab  │ (⌘W)  │ (⌘Q) │ shot   │
└──────┴───────┴──────┴────────┘

Knob 1: Brightness Up/Down, Mute
Knob 2: Switch Apps
```

## Setup Instructions

### Using the Example Config

1. **Copy** the example file:
   ```bash
   cp keyboard_config_3layers_example.yaml keyboard_config.yaml
   ```

2. **Open GUI** at http://localhost:5001

3. **Upload** the config using the "🚀 Upload to Keyboard" button

4. **Test** each layer:
   - Press the layer button to switch
   - Test a few keys on each layer
   - Verify the LEDs show the layer number

### Manual Configuration

To create your own layers:

1. **Open** `keyboard_config.yaml` in a text editor

2. **Copy** an existing layer block (starting from `- buttons:`)

3. **Paste** it below (at the same indentation level)

4. **Edit** the key mappings for your new layer

5. **Save** and upload via the GUI

**Example structure:**
```yaml
layers:
  - buttons:      # Layer 1
      - [key1, key2, key3, key4]
      - [key5, key6, key7, key8]
      - [key9, key10, key11, key12]
    knobs:
      - {cw: action, ccw: action, press: action}
      - {cw: action, ccw: action, press: action}

  - buttons:      # Layer 2 (copy & modify Layer 1)
      - [different, keys, here, ...]
      # ...

  - buttons:      # Layer 3 (copy & modify Layer 1)
      - [more, different, keys, ...]
      # ...
```

## GUI Note

⚠️ **Current Limitation:** The web GUI only edits Layer 1.

To configure multiple layers:
1. Use the GUI to configure Layer 1
2. Manually copy/edit `keyboard_config.yaml` for Layers 2 and 3
3. Upload via the GUI's upload button

🚧 **Future Update:** Full multi-layer GUI support is coming!

## Tips

✅ **Keep Layer 1 universal** - Function keys work everywhere

✅ **Theme your layers** - One for dev, one for productivity, etc.

✅ **Test before committing** - Upload and test each layer's keys

✅ **Label your keyboard** (optional) - Small stickers showing what each layer does

✅ **Use muscle memory** - Keep similar functions on same knobs across layers

## Troubleshooting

**Q: Layer button doesn't switch layers?**
- Make sure you uploaded a config with multiple layers
- Check that each layer has the same button/knob structure

**Q: Keys don't work on Layer 2/3?**
- Verify your YAML indentation is correct
- Each layer must have matching rows/columns count
- Test the config with `ch57x-keyboard-tool validate`

**Q: Can't find the layer button?**
- Check the sides and back of your keyboard
- It's separate from the main key grid
- May be a small button or switch

## Resources

- **Detailed Guide:** See `LAYERS_GUIDE.md` for comprehensive information
- **Example Config:** Check `keyboard_config_3layers_example.yaml`
- **Current Config:** Your active config is in `keyboard_config.yaml`
