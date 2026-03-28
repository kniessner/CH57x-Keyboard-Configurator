#!/usr/bin/env python3
"""
CH57x Keyboard Configuration GUI
Web-based interface for configuring the macro keyboard
"""

from flask import Flask, render_template, request, jsonify
import subprocess
import yaml
import os
import json
import threading

try:
    from pynput import keyboard as pynput_keyboard
    PYNPUT_IMPORT_ERROR = None
except ImportError as exc:
    pynput_keyboard = None
    PYNPUT_IMPORT_ERROR = str(exc)

app = Flask(__name__)

# Shell command storage
SHELL_COMMANDS_FILE = 'shell_commands.json'
shell_command_listener = None
shell_commands = {}

def load_shell_commands():
    """Load shell command mappings from file"""
    global shell_commands
    if os.path.exists(SHELL_COMMANDS_FILE):
        try:
            with open(SHELL_COMMANDS_FILE, 'r') as f:
                shell_commands = json.load(f)
        except Exception as e:
            print(f"Error loading shell commands: {e}")
            shell_commands = {}
    else:
        shell_commands = {}
    return shell_commands

def save_shell_commands():
    """Save shell command mappings to file"""
    try:
        with open(SHELL_COMMANDS_FILE, 'w') as f:
            json.dump(shell_commands, f, indent=2)
        return True
    except Exception as e:
        print(f"Error saving shell commands: {e}")
        return False

class ShellCommandListener:
    """Listens for key combinations and executes associated shell commands"""
    def __init__(self):
        self.active = False
        self.listener = None
        self.pressed_keys = set()

    def start(self):
        """Start listening for key events"""
        if self.active:
            return

        if pynput_keyboard is None:
            raise RuntimeError(
                "Shell command listener is unavailable in this environment. "
                f"{PYNPUT_IMPORT_ERROR}"
            )

        self.active = True
        self.listener = pynput_keyboard.Listener(
            on_press=self.on_press,
            on_release=self.on_release
        )
        self.listener.start()
        print("🎧 Shell command listener started")

    def stop(self):
        """Stop listening for key events"""
        if self.listener:
            self.active = False
            self.listener.stop()
            print("🛑 Shell command listener stopped")

    def on_press(self, key):
        """Handle key press events"""
        try:
            key_str = self.key_to_string(key)
            self.pressed_keys.add(key_str)

            # Check if current combination matches any command
            combo = '+'.join(sorted(self.pressed_keys))
            if combo in shell_commands:
                command = shell_commands[combo]
                print(f"🔧 Executing command for {combo}: {command}")
                self.execute_command(command)
        except Exception as e:
            print(f"Error in on_press: {e}")

    def on_release(self, key):
        """Handle key release events"""
        try:
            key_str = self.key_to_string(key)
            self.pressed_keys.discard(key_str)
        except Exception as e:
            print(f"Error in on_release: {e}")

    def key_to_string(self, key):
        """Convert pynput key to string representation"""
        try:
            if hasattr(key, 'char') and key.char:
                return key.char
            else:
                # Special keys
                key_name = str(key).replace('Key.', '')
                return key_name
        except:
            return str(key)

    def execute_command(self, command):
        """Execute a shell command in the background"""
        def run():
            try:
                subprocess.run(command, shell=True, capture_output=True, text=True)
            except Exception as e:
                print(f"Error executing command: {e}")

        thread = threading.Thread(target=run, daemon=True)
        thread.start()

def get_available_keys():
    """Fetch available keys from ch57x-keyboard-tool show-keys"""
    try:
        result = subprocess.run(
            ['ch57x-keyboard-tool', 'show-keys'],
            capture_output=True,
            text=True
        )

        if result.returncode != 0:
            # Fallback to defaults if command fails
            return get_default_keys()

        output = result.stdout
        modifiers = []
        keys = []
        media_keys = []
        mouse_actions = []

        current_section = None

        for line in output.split('\n'):
            line = line.strip()

            if line.startswith('Modifiers:'):
                current_section = 'modifiers'
            elif line.startswith('Keys:'):
                current_section = 'keys'
            elif line.startswith('Media keys:'):
                current_section = 'media'
            elif line.startswith('Mouse actions:'):
                current_section = 'mouse'
            elif line.startswith('Custom key syntax'):
                current_section = None
            elif line.startswith('- ') and current_section:
                # Extract key name (handle aliases like "alt / opt")
                key_part = line[2:].split('/')[0].strip()
                if current_section == 'modifiers':
                    modifiers.append(key_part)
                elif current_section == 'keys':
                    keys.append(key_part)
                elif current_section == 'media':
                    media_keys.append(key_part)
                elif current_section == 'mouse':
                    mouse_actions.append(key_part)

        knob_actions = list(set(
            [k for k in media_keys if k in ['volumeup', 'volumedown', 'mute', 'next', 'previous', 'prev', 'play']] +
            [k for k in keys if k in ['macbrightnessup', 'macbrightnessdown']]
        ))

        return {
            'modifiers': modifiers,
            'keys': keys,
            'media_keys': media_keys,
            'mouse_actions': mouse_actions,
            'knob_actions': knob_actions
        }
    except Exception as e:
        print(f"Error fetching keys: {e}")
        return get_default_keys()

def get_default_keys():
    """Fallback default keys if command fails"""
    return {
        'modifiers': ['ctrl', 'shift', 'alt', 'opt', 'win', 'cmd',
                     'rctrl', 'rshift', 'ralt', 'ropt', 'rwin', 'rcmd'],
        'keys': [
            'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
            'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
            '1', '2', '3', '4', '5', '6', '7', '8', '9', '0',
            'enter', 'escape', 'backspace', 'tab', 'space',
            'minus', 'equal', 'leftbracket', 'rightbracket', 'backslash',
            'semicolon', 'quote', 'grave', 'comma', 'dot', 'slash',
            'capslock', 'f1', 'f2', 'f3', 'f4', 'f5', 'f6', 'f7', 'f8', 'f9', 'f10', 'f11', 'f12',
            'f13', 'f14', 'f15', 'f16', 'f17', 'f18', 'f19', 'f20', 'f21', 'f22', 'f23', 'f24',
            'printscreen', 'macbrightnessdown', 'macbrightnessup',
            'insert', 'home', 'pageup', 'delete', 'end', 'pagedown',
            'right', 'left', 'down', 'up',
            'numlock', 'numpadslash', 'numpadasterisk', 'numpadminus', 'numpadplus', 'numpadenter',
            'numpad1', 'numpad2', 'numpad3', 'numpad4', 'numpad5',
            'numpad6', 'numpad7', 'numpad8', 'numpad9', 'numpad0', 'numpaddot'
        ],
        'media_keys': [
            'next', 'previous', 'prev', 'stop', 'play', 'mute',
            'volumeup', 'volumedown', 'favorites', 'calculator', 'screenlock'
        ],
        'mouse_actions': ['wheel(-100)', 'click(left+right)', 'move(5,0)', 'drag(left+right,0,5)'],
        'knob_actions': ['volumeup', 'volumedown', 'mute', 'next', 'previous', 'prev',
                        'play', 'macbrightnessup', 'macbrightnessdown']
    }

# Common shortcuts
COMMON_SHORTCUTS = {
    'Copy': 'cmd-c',
    'Paste': 'cmd-v',
    'Cut': 'cmd-x',
    'Undo': 'cmd-z',
    'Redo': 'cmd-shift-z',
    'Save': 'cmd-s',
    'Find': 'cmd-f',
    'Select All': 'cmd-a',
    'New Tab': 'cmd-t',
    'Close Tab': 'cmd-w',
    'Quit': 'cmd-q',
    'Screenshot': 'cmd-shift-4',
    'VS Code: Go to File': 'cmd-p',
    'VS Code: Search': 'cmd-shift-f',
    'VS Code: Terminal': 'ctrl-grave',
    'VS Code: Format': 'cmd-shift-f',
}

@app.route('/')
def index():
    """Serve the main GUI page"""
    return render_template('index.html')

@app.route('/api/key-options')
def get_key_options():
    """Return all available key options"""
    key_data = get_available_keys()
    return jsonify({
        'modifiers': key_data['modifiers'],
        'keys': key_data['keys'],
        'media_keys': key_data['media_keys'],
        'mouse_actions': key_data['mouse_actions'],
        'knob_actions': key_data['knob_actions'],
        'common_shortcuts': COMMON_SHORTCUTS
    })

@app.route('/api/device-info')
def get_device_info():
    """Get keyboard connection information"""
    try:
        result = subprocess.run(
            ['python3', 'detect_keyboard.py'],
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0:
            import json
            device_info = json.loads(result.stdout)
            return jsonify(device_info)
        else:
            return jsonify({'connected': False, 'error': 'Detection failed'})
    except Exception as e:
        return jsonify({'connected': False, 'error': str(e)})

@app.route('/api/load-config', methods=['GET'])
def load_config():
    """Load existing configuration"""
    config_file = 'keyboard_config.yaml'
    if os.path.exists(config_file):
        try:
            with open(config_file, 'r') as f:
                config = yaml.safe_load(f)
            # Return full config including actual rows/columns
            return jsonify({'success': True, 'config': config})
        except Exception as e:
            return jsonify({'success': False, 'error': str(e)})
    # Return default config
    default_config = {
        'orientation': 'normal',
        'rows': 3,
        'columns': 4,
        'knobs': 2,
        'layers': [{
            'buttons': [
                ['f13', 'f14', 'f15', 'f16'],
                ['f17', 'f18', 'f19', 'f20'],
                ['f21', 'f22', 'f23', 'f24']
            ],
            'knobs': [
                {'cw': 'volumeup', 'ccw': 'volumedown', 'press': 'mute'},
                {'cw': 'next', 'ccw': 'previous', 'press': 'play'}
            ]
        }]
    }
    return jsonify({'success': True, 'config': default_config})

@app.route('/api/save-config', methods=['POST'])
def save_config():
    """Save configuration to YAML file"""
    try:
        data = request.json

        # Build the layer structure
        layer = {
            'buttons': data.get('buttons', [])
        }

        # Add knobs if present
        knob_configs = data.get('knobConfigs', [])
        if knob_configs:
            layer['knobs'] = knob_configs

        config = {
            'orientation': data.get('orientation', 'normal'),
            'rows': data.get('rows', 3),
            'columns': data.get('columns', 4),
            'knobs': data.get('knobs', 2),
            'layers': [layer]
        }

        # Save to file with proper YAML formatting
        config_file = 'keyboard_config.yaml'
        with open(config_file, 'w') as f:
            # Write header comment
            f.write('# CH57x Macro Keyboard Configuration\n')
            f.write('# Generated by Keyboard Configurator GUI\n\n')

            # Custom representer to force string quoting
            def str_representer(dumper, data):
                if any(char in data for char in [',', '!', ':', '{', '}', '[', ']', '&', '*', '#', '?', '|', '-', '<', '>', '=', '%', '@', '`']):
                    return dumper.represent_scalar('tag:yaml.org,2002:str', data, style="'")
                return dumper.represent_scalar('tag:yaml.org,2002:str', data)

            yaml.add_representer(str, str_representer)
            yaml.dump(config, f, default_flow_style=None, sort_keys=False, allow_unicode=True)

        return jsonify({'success': True, 'message': 'Configuration saved successfully'})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)})

@app.route('/api/validate-config', methods=['POST'])
def validate_config():
    """Validate configuration using ch57x-keyboard-tool"""
    try:
        data = request.json

        # Build the layer structure (same as save)
        layer = {
            'buttons': data.get('buttons', [])
        }

        # Add knobs if present
        knob_configs = data.get('knobConfigs', [])
        if knob_configs:
            layer['knobs'] = knob_configs

        config = {
            'orientation': data.get('orientation', 'normal'),
            'rows': data.get('rows', 3),
            'columns': data.get('columns', 4),
            'knobs': data.get('knobs', 2),
            'layers': [layer]
        }

        # Custom representer to force string quoting (same as save)
        def str_representer(dumper, data):
            if any(char in data for char in [',', '!', ':', '{', '}', '[', ']', '&', '*', '#', '?', '|', '-', '<', '>', '=', '%', '@', '`']):
                return dumper.represent_scalar('tag:yaml.org,2002:str', data, style="'")
            return dumper.represent_scalar('tag:yaml.org,2002:str', data)

        yaml.add_representer(str, str_representer)
        config_yaml = yaml.dump(config, default_flow_style=None, sort_keys=False, allow_unicode=True)

        # Run validation
        result = subprocess.run(
            ['ch57x-keyboard-tool', 'validate'],
            input=config_yaml,
            capture_output=True,
            text=True
        )

        if result.returncode == 0:
            return jsonify({'success': True, 'message': 'Configuration is valid ✓'})
        else:
            return jsonify({'success': False, 'error': result.stderr})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)})

@app.route('/api/upload-config', methods=['POST'])
def upload_config():
    """Upload configuration to keyboard using sudo"""
    try:
        config_file = 'keyboard_config.yaml'

        if not os.path.exists(config_file):
            return jsonify({'success': False, 'error': 'Config file not found. Save first.'})

        # Check if keyboard is connected
        check_result = subprocess.run(
            ['./check_keyboard_usb.sh'],
            capture_output=True,
            text=True,
            cwd=os.getcwd()
        )

        if check_result.returncode != 0:
            return jsonify({
                'success': False,
                'error': 'Keyboard not detected. Please connect your CH57x keyboard.'
            })

        # Upload using sudo (passwordless if configured)
        # This reads the config file and pipes it to the tool
        with open(config_file, 'r') as f:
            config_content = f.read()

        result = subprocess.run(
            ['sudo', 'ch57x-keyboard-tool', 'upload'],
            input=config_content,
            capture_output=True,
            text=True,
            cwd=os.getcwd()
        )

        if result.returncode == 0:
            return jsonify({
                'success': True,
                'message': '✅ Configuration uploaded to keyboard successfully!'
            })
        else:
            error_msg = result.stderr or result.stdout or 'Upload failed'

            # Check if it's a password prompt (sudo not configured for passwordless)
            if 'password' in error_msg.lower() or 'sudo' in error_msg.lower():
                return jsonify({
                    'success': False,
                    'error': 'Password required. Run ./setup_passwordless_upload.sh to enable passwordless uploads.'
                })

            return jsonify({
                'success': False,
                'error': f'Upload failed: {error_msg}'
            })

    except Exception as e:
        return jsonify({'success': False, 'error': str(e)})

@app.route('/api/list-presets', methods=['GET'])
def list_presets():
    """List all available preset files"""
    try:
        presets_dir = 'presets'
        if not os.path.exists(presets_dir):
            os.makedirs(presets_dir)
            return jsonify({'success': True, 'presets': []})

        preset_files = [f.replace('.yaml', '') for f in os.listdir(presets_dir) if f.endswith('.yaml')]
        return jsonify({'success': True, 'presets': sorted(preset_files)})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)})

@app.route('/api/save-preset', methods=['POST'])
def save_preset():
    """Save current configuration as a preset"""
    try:
        data = request.json
        preset_name = data.get('preset_name', '').strip()

        if not preset_name:
            return jsonify({'success': False, 'error': 'Preset name is required'})

        # Sanitize preset name
        preset_name = "".join(c for c in preset_name if c.isalnum() or c in (' ', '-', '_')).strip()

        if not preset_name:
            return jsonify({'success': False, 'error': 'Invalid preset name'})

        presets_dir = 'presets'
        if not os.path.exists(presets_dir):
            os.makedirs(presets_dir)

        preset_path = os.path.join(presets_dir, f'{preset_name}.yaml')

        # Build the layer structure
        layer = {
            'buttons': data.get('buttons', [])
        }

        # Add knobs if present
        knob_configs = data.get('knobConfigs', [])
        if knob_configs:
            layer['knobs'] = knob_configs

        config = {
            'orientation': data.get('orientation', 'normal'),
            'rows': data.get('rows', 3),
            'columns': data.get('columns', 4),
            'knobs': data.get('knobs', 2),
            'layers': [layer]
        }

        # Save to preset file
        with open(preset_path, 'w') as f:
            f.write(f'# CH57x Keyboard Preset: {preset_name}\n')
            f.write('# Saved from Keyboard Configurator GUI\n\n')

            def str_representer(dumper, data):
                if any(char in data for char in [',', '!', ':', '{', '}', '[', ']', '&', '*', '#', '?', '|', '-', '<', '>', '=', '%', '@', '`']):
                    return dumper.represent_scalar('tag:yaml.org,2002:str', data, style="'")
                return dumper.represent_scalar('tag:yaml.org,2002:str', data)

            yaml.add_representer(str, str_representer)
            yaml.dump(config, f, default_flow_style=None, sort_keys=False, allow_unicode=True)

        return jsonify({'success': True, 'message': f'Preset "{preset_name}" saved successfully'})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)})

@app.route('/api/load-preset', methods=['POST'])
def load_preset():
    """Load a preset configuration"""
    try:
        data = request.json
        preset_name = data.get('preset_name', '').strip()

        if not preset_name:
            return jsonify({'success': False, 'error': 'Preset name is required'})

        presets_dir = 'presets'
        preset_path = os.path.join(presets_dir, f'{preset_name}.yaml')

        if not os.path.exists(preset_path):
            return jsonify({'success': False, 'error': 'Preset not found'})

        with open(preset_path, 'r') as f:
            config = yaml.safe_load(f)

        return jsonify({'success': True, 'config': config})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)})

@app.route('/api/shell-commands', methods=['GET'])
def get_shell_commands():
    """Get all shell command mappings"""
    try:
        return jsonify({'success': True, 'commands': shell_commands})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)})

@app.route('/api/shell-commands', methods=['POST'])
def add_shell_command():
    """Add or update a shell command mapping"""
    try:
        data = request.json
        key_combo = data.get('key_combo', '').strip()
        command = data.get('command', '').strip()

        if not key_combo or not command:
            return jsonify({'success': False, 'error': 'Key combination and command are required'})

        shell_commands[key_combo] = command
        if save_shell_commands():
            return jsonify({
                'success': True,
                'message': f'Command mapped to {key_combo}',
                'commands': shell_commands
            })
        else:
            return jsonify({'success': False, 'error': 'Failed to save commands'})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)})

@app.route('/api/shell-commands/<key_combo>', methods=['DELETE'])
def delete_shell_command(key_combo):
    """Delete a shell command mapping"""
    try:
        if key_combo in shell_commands:
            del shell_commands[key_combo]
            if save_shell_commands():
                return jsonify({
                    'success': True,
                    'message': f'Command mapping for {key_combo} deleted',
                    'commands': shell_commands
                })
            else:
                return jsonify({'success': False, 'error': 'Failed to save commands'})
        else:
            return jsonify({'success': False, 'error': 'Key combination not found'})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)})

@app.route('/api/shell-commands/listener', methods=['POST'])
def toggle_listener():
    """Start or stop the shell command listener"""
    global shell_command_listener
    try:
        data = request.json
        action = data.get('action', 'start')

        if action == 'start':
            if not shell_command_listener:
                shell_command_listener = ShellCommandListener()
            shell_command_listener.start()
            return jsonify({'success': True, 'message': 'Listener started', 'active': True})
        elif action == 'stop':
            if shell_command_listener:
                shell_command_listener.stop()
            return jsonify({'success': True, 'message': 'Listener stopped', 'active': False})
        else:
            return jsonify({'success': False, 'error': 'Invalid action'})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)})

@app.route('/api/shell-commands/listener/status', methods=['GET'])
def listener_status():
    """Get the status of the shell command listener"""
    try:
        active = shell_command_listener.active if shell_command_listener else False
        return jsonify({'success': True, 'active': active})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)})

@app.route('/api/set-led', methods=['POST'])
def set_led():
    """Set LED backlight mode by updating config and uploading"""
    try:
        data = request.json
        mode = data.get('mode', 'off')
        color = data.get('color', 'cyan')

        # LED modes are configured in YAML file with format:
        # led_mode: !Off
        # led_mode: !Backlight cyan
        # led_mode: !Shock red
        # led_mode: !Shock2 green
        # led_mode: !Press blue

        config_file = 'keyboard_config.yaml'

        # Load existing config
        if not os.path.exists(config_file):
            return jsonify({'success': False, 'error': 'Config file not found'})

        with open(config_file, 'r') as f:
            config = yaml.safe_load(f)

        # Set LED mode in config
        if mode == 'off':
            led_value = yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG  # Plain string
            config['led_mode'] = yaml.nodes.ScalarNode(tag='!Off', value='')
        else:
            # Capitalize mode name for YAML tag (Backlight, Shock, Shock2, Press)
            tag_name = mode.capitalize() if mode != 'shock2' else 'Shock2'
            # For modes with color, the value is the color
            config['led_mode'] = yaml.nodes.ScalarNode(tag=f'!{tag_name}', value=color)

        # Save config with LED mode
        with open(config_file, 'w') as f:
            f.write('# CH57x Macro Keyboard Configuration\n')
            f.write('# Generated by Keyboard Configurator GUI\n\n')

            # Manually construct LED mode line
            if mode == 'off':
                f.write('led_mode: !Off\n')
            else:
                tag_name = mode.capitalize() if mode != 'shock2' else 'Shock2'
                f.write(f'led_mode: !{tag_name} {color}\n')

            # Write rest of config
            f.write(f'orientation: {config.get("orientation", "normal")}\n')
            f.write(f'rows: {config.get("rows", 3)}\n')
            f.write(f'columns: {config.get("columns", 4)}\n')
            f.write(f'knobs: {config.get("knobs", 2)}\n')

            # Custom representer for strings
            def str_representer(dumper, data):
                if any(char in data for char in [',', '!', ':', '{', '}', '[', ']', '&', '*', '#', '?', '|', '-', '<', '>', '=', '%', '@', '`']):
                    return dumper.represent_scalar('tag:yaml.org,2002:str', data, style="'")
                return dumper.represent_scalar('tag:yaml.org,2002:str', data)

            yaml.add_representer(str, str_representer)

            # Write layers
            f.write('layers:\n')
            f.write(yaml.dump(config['layers'], default_flow_style=None, sort_keys=False))

        # Upload to keyboard
        with open(config_file, 'r') as f:
            config_content = f.read()

        result = subprocess.run(
            ['sudo', 'ch57x-keyboard-tool', 'upload'],
            input=config_content,
            capture_output=True,
            text=True
        )

        if result.returncode == 0:
            if mode == 'off':
                message = f'✅ LED turned off and uploaded to keyboard'
            else:
                message = f'✅ LED set to {mode} mode with {color} color and uploaded to keyboard'

            return jsonify({
                'success': True,
                'message': message
            })
        else:
            error_msg = result.stderr or result.stdout or 'Upload failed'
            return jsonify({
                'success': False,
                'error': f'Failed to upload LED config: {error_msg}'
            })

    except Exception as e:
        return jsonify({'success': False, 'error': str(e)})

if __name__ == '__main__':
    print("\n⌨️  CH57x Keyboard Configuration GUI")
    print("=" * 50)

    # Load shell commands
    load_shell_commands()
    print(f"📋 Loaded {len(shell_commands)} shell command mapping(s)")

    print("\n🌐 Opening web interface at http://localhost:5001")
    print("📝 Press Ctrl+C to stop the server\n")

    try:
        app.run(debug=True, host='127.0.0.1', port=5001, use_reloader=False)
    finally:
        # Clean up listener on exit
        if shell_command_listener:
            shell_command_listener.stop()
