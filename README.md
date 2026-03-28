# CH57x Macro Keyboard Toolkit

Configure, validate, and upload layouts for a CH57x macro keyboard on macOS.

This project wraps the low-level CH57x tooling in a cleaner workflow:
- a single CLI entrypoint: `./keyboard.sh`
- a terminal UI for quick preset-driven workflows
- a local web UI for editing layouts visually
- preset examples you can adapt instead of starting from scratch
- helper flows for validation, backups, testing, Karabiner, and passwordless uploads

## Why This Repo Exists

The raw CH57x toolchain works, but the day-to-day ergonomics are rough. This repo makes the keyboard easier to live with by adding:

- a shareable starter config
- a visual editor
- repeatable upload and validation commands
- repo-safe defaults that avoid committing local logs, virtualenvs, and backup files
- documentation for layers, Bluetooth behavior, shell commands, and Karabiner integration

## Quick Start

Clone the repo, then:

```bash
./keyboard.sh install
./keyboard.sh check
./keyboard.sh tui
./keyboard.sh gui
```

That gives you:
1. the `ch57x-keyboard-tool` binary
2. a connection check for the keyboard over USB
3. a terminal UI for quick actions and preset application
4. a local configurator at `http://127.0.0.1:5001`

If you prefer the terminal flow instead of the GUI:

```bash
./keyboard.sh validate
./keyboard.sh upload
```

## What You Can Do

### Visual Configuration
- Edit button and knob mappings in a local web UI
- Load and save presets
- inspect detected device information
- manage shell-command bindings from the browser

### Terminal Workflow
- Run `./keyboard.sh tui` for a keyboard-friendly terminal interface
- Inspect the current config without leaving the terminal
- Apply presets directly to `keyboard_config.yaml`
- Trigger check, validate, upload, backup, and test actions from one screen

### Safe Command-Line Workflow
- `./keyboard.sh check` to confirm the keyboard is visible
- `./keyboard.sh validate` to catch config errors before upload
- `./keyboard.sh upload` to validate, back up, and flash the current config
- `./keyboard.sh backup` to save timestamped local snapshots
- `./keyboard.sh test` to temporarily load a position-finding layout

### Advanced Integration
- `./keyboard.sh karabiner` to install the bundled Karabiner example
- `./keyboard.sh passwordless` to configure passwordless upload support
- shell-command bindings for launching apps or running scripts from key presses

## CLI

`keyboard.sh` is the public shell interface for the repo.

```bash
./keyboard.sh help
```

Available commands:

```text
check
validate
upload
backup
test
karabiner
passwordless
install
show
tui
gui
gui-start
gui-stop
gui-status
gui-restart
menu
help
```

## Starter Layout

The default tracked config is intentionally neutral:

```text
┌─────┬─────┬─────┬─────┐
│ F13 │ F14 │ F15 │ F16 │
├─────┼─────┼─────┼─────┤
│ F17 │ F18 │ F19 │ F20 │
├─────┼─────┼─────┼─────┤
│ F21 │ F22 │ F23 │ F24 │
└─────┴─────┴─────┴─────┘

Knob 1: volume up/down + mute
Knob 2: next/previous + play
```

Using F13-F24 as a baseline keeps the hardware layout generic and makes it easy to layer on Karabiner rules or app-specific automation later.

## Repository Layout

| Path | Purpose |
|------|---------|
| `keyboard.sh` | Main CLI entrypoint |
| `keyboard_config.yaml` | Current tracked starter config |
| `keyboard_config_gui.py` | Flask-based configurator backend |
| `scripts/` | Implementation shell scripts used by the CLI |
| `scripts/lib/common.sh` | Shared shell helpers |
| `presets/` | Reusable configuration examples |
| `doc/` | Supporting documentation |
| `shell_commands.json` | Local shell-command bindings, empty by default |

## Typical Workflow

1. Install the CH57x tool with `./keyboard.sh install`.
2. Connect the keyboard over USB and run `./keyboard.sh check`.
3. Open `./keyboard.sh gui` or edit `keyboard_config.yaml` directly.
4. Or use `./keyboard.sh tui` if you want a terminal-first flow.
5. Run `./keyboard.sh validate`.
6. Run `./keyboard.sh upload`.
7. Add Karabiner or shell-command bindings if you want higher-level automation.

## Presets and Customization

The repo includes several example layouts under `presets/`, including:
- a minimal starter preset
- a multi-layer example
- reusable profile ideas for development, media, and productivity

You can keep `keyboard_config.yaml` as your active layout and use the presets as reference material or import targets in the GUI.

## Shell Command Bindings

The web UI can map key combinations to shell commands. This is useful for:
- launching apps
- triggering scripts
- running local automation tasks

Examples:
- `open -a Calculator`
- `screencapture -c`
- `/absolute/path/to/script.sh`

More detail is in [`doc/SHELL_COMMANDS.md`](doc/SHELL_COMMANDS.md).

Shell command bindings are disabled by default in the GUI. To enable them intentionally for local use, start the GUI with `ENABLE_SHELL_COMMANDS=1 ./keyboard.sh gui`.

## Troubleshooting

If the keyboard is connected but not detected:
- run `./keyboard.sh check`
- try another USB port or cable
- prefer direct USB while uploading, even if Bluetooth input works

If validation or upload fails:
- run `./keyboard.sh validate`
- confirm `ch57x-keyboard-tool` is installed and on `PATH`
- check for YAML syntax or unsupported key names

If the GUI fails to start:
- rerun `./keyboard.sh gui`
- the launcher will recreate the local Python environment if needed
- Flask debug mode is off by default; set `KEYBOARD_GUI_DEBUG=1` only for local troubleshooting

If uploads keep prompting for `sudo` and you want to avoid that:
- run `./keyboard.sh passwordless`

## Documentation

- [`doc/AVAILABLE_KEYS.md`](doc/AVAILABLE_KEYS.md)
- [`doc/BLUETOOTH_SUPPORT.md`](doc/BLUETOOTH_SUPPORT.md)
- [`doc/LAYER_SWITCHING.md`](doc/LAYER_SWITCHING.md)
- [`doc/LAYERS_GUIDE.md`](doc/LAYERS_GUIDE.md)
- [`doc/KNOB_PRESETS.md`](doc/KNOB_PRESETS.md)
- [`doc/PASSWORDLESS_SETUP.md`](doc/PASSWORDLESS_SETUP.md)
- [`doc/QUICK_LAYER_GUIDE.md`](doc/QUICK_LAYER_GUIDE.md)
- [`doc/SHELL_COMMANDS.md`](doc/SHELL_COMMANDS.md)

## Notes

- This project is currently macOS-focused.
- The repo is set up to stay shareable: local logs, backups, virtualenvs, and personal workspace files are intentionally ignored.
- The keyboard stores the flashed configuration in onboard memory, so uploaded mappings persist across machines.
