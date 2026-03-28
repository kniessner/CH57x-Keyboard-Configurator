# CH57x Macro Keyboard Setup

Utilities and a local web UI for configuring a CH57x macro keyboard on macOS.

This repo is now organized as a shareable baseline:
- `keyboard_config.yaml` is a neutral starter layout.
- `presets/` contains reusable examples instead of personal working copies.
- local runtime files, backups, `.claude/`, logs, and virtualenvs are ignored.

## Quick Start

Install the CH57x CLI first:

```bash
./install_ch57x_tool.sh
```

Then launch the configurator:

```bash
./run_gui.sh
```

The launcher creates `venv/` if needed, installs dependencies from `requirements.txt`, and starts the GUI at `http://127.0.0.1:5001`.

If you prefer the menu wrapper:

```bash
./manage.sh
```

## What’s Included

| Path | Purpose |
|------|---------|
| `keyboard_config.yaml` | Starter config tracked in git |
| `presets/main.yaml` | Minimal baseline preset |
| `presets/keyboard_config.yaml` | Karabiner trigger example |
| `presets/keyboard_config_3layers_example.yaml` | Three-layer example layout |
| `presets/keyboard_profiles.yaml` | Reusable profile ideas |
| `keyboard_config_gui.py` | Flask app for editing and upload |
| `run_gui.sh` | Launch GUI in a local virtualenv |
| `gui_control.sh` | Start/stop/status helper for the GUI |
| `upload_config.sh` | Validate and upload the current YAML config |
| `backup_config.sh` | Create timestamped local backups |
| `setup_karabiner.sh` | Install the bundled Karabiner rule example |
| `shell_commands.json` | Local key-to-command mappings, empty by default |

## Starter Layout

The tracked default config keeps the keypad intentionally safe and generic:

```text
┌─────┬─────┬─────┬─────┐
│ F13 │ F14 │ F15 │ F16 │
├─────┼─────┼─────┼─────┤
│ F17 │ F18 │ F19 │ F20 │
├─────┼─────┼─────┼─────┤
│ F21 │ F22 │ F23 │ F24 │
└─────┴─────┴─────┴─────┘

Knob 1: Volume up/down + mute
Knob 2: Track next/previous + play
```

Using F13-F24 is a good default because those keys rarely conflict with normal shortcuts and are easy to remap in Karabiner-Elements.

## Common Tasks

Check that the keyboard is visible over USB:

```bash
./check_keyboard_usb.sh
```

Validate the current config without uploading:

```bash
./validate_config.sh
```

Upload the current config:

```bash
./upload_config.sh
```

Create a local backup before experimenting:

```bash
./backup_config.sh
```

Install the sample Karabiner rule for turning F-keys into typed strings:

```bash
./setup_karabiner.sh
```

## Editing the Config

The GUI is the easiest path, but the YAML format is straightforward:

```yaml
orientation: normal
rows: 3
columns: 4
knobs: 2
layers:
  - buttons:
      - [f13, f14, f15, f16]
      - [cmd-c, cmd-v, cmd-x, cmd-z]
      - [left, down, up, right]
    knobs:
      - cw: volumeup
        ccw: volumedown
        press: mute
      - cw: next
        ccw: previous
        press: play
```

Run `ch57x-keyboard-tool show-keys` to see valid key names for your firmware/tool version.

## Shell Command Bindings

The GUI can bind shell commands to detected key combinations. The checked-in `shell_commands.json` starts empty on purpose so personal automations are not shared by default.

Examples:
- `open -a Calculator`
- `screencapture -c`
- `/absolute/path/to/script.sh`

More detail is in [`doc/SHELL_COMMANDS.md`](doc/SHELL_COMMANDS.md).

## Local-Only Files

These are intentionally not part of the shareable project state:
- `venv/`
- `gui.log`
- `config_backups/`
- `.claude/`
- macOS `.DS_Store` files
- ad-hoc preset copies such as `presets/* copy*.yaml`

## Troubleshooting

If the GUI fails to start, the usual cause is a missing dependency inside `venv/`. Re-running `./run_gui.sh` or `./gui_control.sh start` will install anything missing from `requirements.txt`.

If upload fails:
- confirm the keyboard is connected over USB
- run `./validate_config.sh`
- make sure `ch57x-keyboard-tool` is installed and on `PATH`
- expect a `sudo` password prompt unless you configured passwordless upload

If Karabiner rules do not trigger:
- grant Input Monitoring permission
- enable the installed rule in Karabiner-Elements
- use F13-F24 mappings as the hardware-side trigger keys

## Related Docs

- [`doc/AVAILABLE_KEYS.md`](doc/AVAILABLE_KEYS.md)
- [`doc/BLUETOOTH_SUPPORT.md`](doc/BLUETOOTH_SUPPORT.md)
- [`doc/LAYER_SWITCHING.md`](doc/LAYER_SWITCHING.md)
- [`doc/LAYERS_GUIDE.md`](doc/LAYERS_GUIDE.md)
- [`doc/KNOB_PRESETS.md`](doc/KNOB_PRESETS.md)
- [`doc/PASSWORDLESS_SETUP.md`](doc/PASSWORDLESS_SETUP.md)
- [`doc/QUICK_LAYER_GUIDE.md`](doc/QUICK_LAYER_GUIDE.md)
- [`doc/SHELL_COMMANDS.md`](doc/SHELL_COMMANDS.md)
