# Passwordless Keyboard Upload Setup

## Quick Setup

Run this once to enable passwordless uploads:

```bash
./keyboard.sh passwordless
```

This will:
1. Create a sudoers rule allowing `ch57x-keyboard-tool` to run without password
2. Only affect the keyboard tool - all other sudo commands still need password
3. Enable the GUI to upload configs seamlessly without password prompts

## What it does

Creates a rule in `/etc/sudoers.d/ch57x-keyboard-tool`:
```
your_username ALL=(ALL) NOPASSWD: /path/to/ch57x-keyboard-tool
```

## Benefits

- ✅ No more password prompts when uploading configs
- ✅ Auto-upload in GUI works seamlessly
- ✅ LED controls work without interruption
- ✅ Secure - only affects the keyboard tool

## Testing

After running the setup script, test it:

```bash
# This should work without asking for password
echo "test" | sudo ch57x-keyboard-tool validate
```

## Removing

To remove passwordless access later:

```bash
sudo rm /etc/sudoers.d/ch57x-keyboard-tool
```

## Security

- Only the `ch57x-keyboard-tool` command can run without password
- Limited to USB device access for keyboard configuration
- No other system commands are affected
- Standard security best practice for device-specific tools
