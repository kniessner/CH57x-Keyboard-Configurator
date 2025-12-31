# Bluetooth Support for CH57x Keyboard

## Current Status

Your keyboard **MINI_KEYBOARD** is detected and connected via Bluetooth! 🎉

However, **configuration uploads currently require USB connection**. The `ch57x-keyboard-tool` communicates directly with the keyboard's USB HID interface, which isn't accessible over Bluetooth.

## What Works

✅ **Bluetooth Connection**
- Your keyboard works perfectly over Bluetooth
- All programmed keys and shortcuts function normally
- Battery-powered operation

✅ **Device Detection**
- The GUI now detects your Bluetooth connection
- Shows device information (name, address, battery level, firmware)

✅ **Configuration Editing**
- You can still use the GUI to design your layout
- Save configurations locally
- Test and validate configs

## What Doesn't Work (Yet)

❌ **Direct Bluetooth Upload**
- Cannot upload configurations over Bluetooth
- The tool requires USB HID access

## Workaround: USB Upload for Bluetooth Keyboards

### Method 1: Temporary USB Connection (Recommended)

1. **Design your configuration in the GUI** (works while on Bluetooth)
2. **Save your config** - it's stored in `keyboard_config.yaml`
3. **Connect keyboard via USB** temporarily:
   - Plug in a USB cable
   - The keyboard will switch to USB mode
4. **Upload the configuration:**
   ```bash
   sudo ch57x-keyboard-tool upload < keyboard_config.yaml
   ```
5. **Unplug USB** and return to Bluetooth

Your new configuration persists! The keyboard stores the config in its internal memory.

### Method 2: Batch Updates

If you frequently update configs:

1. Design multiple configurations
2. Test them in the GUI
3. Save each as a separate file:
   ```bash
   cp keyboard_config.yaml configs/work_mode.yaml
   cp keyboard_config.yaml configs/game_mode.yaml
   ```
4. Connect via USB once
5. Upload all configs in sequence:
   ```bash
   for config in configs/*.yaml; do
       echo "Uploading $config..."
       sudo ch57x-keyboard-tool upload < "$config"
       sleep 2
   done
   ```

## Future Bluetooth Upload Support

To enable native Bluetooth uploads, we would need:

### Option A: Tool Modification (Advanced)

Modify `ch57x-keyboard-tool` to support Bluetooth HID:

1. **Detect Bluetooth HID devices** via IOBluetooth framework
2. **Open HID connection** to the keyboard
3. **Send configuration data** using HID reports
4. **Verify upload** succeeded

### Option B: Bridge Script (Intermediate)

Create a macOS-specific bridge:

1. **Python script** using `PyObjC` to access Bluetooth HID
2. **Translate** config to HID reports
3. **Send** via IOBluetoothDevice

### Option C: Dual-Mode Upload

Detect connection type and use appropriate method:

```python
def upload_config(config_file):
    device = detect_keyboard()

    if device['type'] == 'USB':
        # Use existing tool
        subprocess.run(['ch57x-keyboard-tool', 'upload'], stdin=open(config_file))
    elif device['type'] == 'Bluetooth':
        # Use Bluetooth HID upload
        bluetooth_upload(device['address'], config_file)
```

## Your Current Setup

```yaml
Device: MINI_KEYBOARD
Type: Bluetooth
Address: 3A:37:30:BF:6A:26
Vendor ID: 0x05AC
Product ID: 0x022C
Battery: 100%
Firmware: 0.0.1
```

## Practical Workflow

**For daily use:**
1. Keep keyboard on Bluetooth (wireless freedom!)
2. Design configs in the GUI anytime
3. Once per week/month: Connect via USB to upload batch of new configs
4. Back to Bluetooth

**For development:**
1. Keep USB cable handy
2. Quick plug-in for uploads
3. Immediate testing over Bluetooth

## Benefits of Current Approach

✅ **Battery Life** - Most time on Bluetooth, minimal USB usage
✅ **Wireless Freedom** - Only connect cable when updating config
✅ **Safe Updates** - USB connection ensures reliable uploads
✅ **No Tool Modifications** - Uses standard, tested tool

## Quick Reference

### Check Connection Status
```bash
python3 detect_keyboard.py
```

### Upload via USB (when connected)
```bash
sudo ch57x-keyboard-tool upload < keyboard_config.yaml
```

### Verify Keyboard Works
```bash
# After upload, test keys
# (they work over Bluetooth or USB!)
```

---

**Bottom Line:** Your keyboard works great over Bluetooth! Just connect USB temporarily when you want to upload new configurations. The configs persist in the keyboard's memory, so you can enjoy wireless operation 99% of the time.
