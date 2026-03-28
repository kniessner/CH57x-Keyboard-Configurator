#!/usr/bin/env python3
"""
Detect CH57x Keyboard - USB or Bluetooth
"""

import subprocess
import json
import re
import shutil
import platform

def detect_usb_keyboard():
    """Check if keyboard is connected via USB"""
    try:
        if shutil.which('system_profiler'):
            result = subprocess.run(
                ['system_profiler', 'SPUSBDataType', '-json'],
                capture_output=True,
                text=True,
                timeout=5
            )

            if result.returncode == 0:
                data = json.loads(result.stdout)
                # Look for CH57x devices (Vendor ID: 0x1189)
                for bus in data.get('SPUSBDataType', []):
                    for item in bus.get('_items', []):
                        if 'vendor_id' in item:
                            vendor_id = item.get('vendor_id', '')
                            if '0x1189' in vendor_id or '1189' in vendor_id:
                                return {
                                    'connected': True,
                                    'type': 'USB',
                                    'name': item.get('_name', 'Unknown'),
                                    'vendor_id': vendor_id,
                                    'product_id': item.get('product_id', 'Unknown'),
                                    'serial': item.get('serial_num', 'N/A'),
                                    'location_id': item.get('location_id', 'N/A')
                                }

        if shutil.which('lsusb'):
            result = subprocess.run(
                ['lsusb'],
                capture_output=True,
                text=True,
                timeout=5
            )

            if result.returncode == 0:
                for line in result.stdout.splitlines():
                    match = re.search(
                        r'^Bus\s+(\d+)\s+Device\s+(\d+):\s+ID\s+([0-9a-fA-F]{4}):([0-9a-fA-F]{4})\s+(.+)$',
                        line
                    )
                    if not match:
                        continue

                    bus, device, vendor_id, product_id, name = match.groups()
                    if vendor_id.lower() == '1189':
                        return {
                            'connected': True,
                            'type': 'USB',
                            'name': name.strip(),
                            'vendor_id': f'0x{vendor_id.lower()}',
                            'product_id': f'0x{product_id.lower()}',
                            'bus': bus,
                            'device': device,
                            'platform': platform.system()
                        }
    except Exception as e:
        print(f"USB detection error: {e}")

    return {'connected': False, 'type': 'USB'}

def detect_bluetooth_keyboard():
    """Check if keyboard is connected via Bluetooth"""
    if not shutil.which('system_profiler'):
        return {'connected': False, 'type': 'Bluetooth'}

    try:
        result = subprocess.run(
            ['system_profiler', 'SPBluetoothDataType'],
            capture_output=True,
            text=True,
            timeout=5
        )

        if result.returncode == 0:
            output = result.stdout

            # Look for connected HID devices (keyboards)
            devices = []
            current_device = {}
            in_connected_section = False

            for line in output.split('\n'):
                line = line.strip()

                if 'Connected:' in line:
                    in_connected_section = True
                    continue
                elif 'Not Connected:' in line:
                    in_connected_section = False
                    continue

                if not in_connected_section:
                    continue

                # Device name (appears before properties)
                if line and not line.startswith(('Address:', 'Vendor', 'Product', 'Battery', 'Firmware', 'Minor', 'Services', 'RSSI')):
                    if line.endswith(':'):
                        if current_device and 'name' in current_device:
                            devices.append(current_device)
                        current_device = {'name': line.rstrip(':')}

                # Parse properties
                if 'Address:' in line:
                    current_device['address'] = line.split(':', 1)[1].strip()
                elif 'Vendor ID:' in line:
                    current_device['vendor_id'] = line.split(':', 1)[1].strip()
                elif 'Product ID:' in line:
                    current_device['product_id'] = line.split(':', 1)[1].strip()
                elif 'Minor Type:' in line:
                    minor_type = line.split(':', 1)[1].strip()
                    current_device['device_type'] = minor_type
                elif 'Battery Level:' in line:
                    current_device['battery'] = line.split(':', 1)[1].strip()
                elif 'Firmware Version:' in line:
                    current_device['firmware'] = line.split(':', 1)[1].strip()

            # Add last device
            if current_device and 'name' in current_device:
                devices.append(current_device)

            # Look for keyboards
            for device in devices:
                if device.get('device_type') == 'Keyboard':
                    # Check if it might be a CH57x or macro keyboard
                    name = device.get('name', '').lower()
                    if any(keyword in name for keyword in ['macro', 'ch57', 'programmable', 'keypad']):
                        return {
                            'connected': True,
                            'type': 'Bluetooth',
                            'name': device.get('name', 'Unknown'),
                            'address': device.get('address', 'N/A'),
                            'vendor_id': device.get('vendor_id', 'N/A'),
                            'product_id': device.get('product_id', 'N/A'),
                            'battery': device.get('battery', 'N/A'),
                            'firmware': device.get('firmware', 'N/A')
                        }

            # If we found any keyboard, return the first one
            for device in devices:
                if device.get('device_type') == 'Keyboard':
                    return {
                        'connected': True,
                        'type': 'Bluetooth',
                        'name': device.get('name', 'Unknown'),
                        'address': device.get('address', 'N/A'),
                        'vendor_id': device.get('vendor_id', 'N/A'),
                        'product_id': device.get('product_id', 'N/A'),
                        'battery': device.get('battery', 'N/A'),
                        'firmware': device.get('firmware', 'N/A'),
                        'note': 'Detected as generic Bluetooth keyboard'
                    }

    except Exception as e:
        print(f"Bluetooth detection error: {e}")

    return {'connected': False, 'type': 'Bluetooth'}

def detect_keyboard():
    """Detect keyboard via USB or Bluetooth"""

    # Try USB first (preferred for uploading)
    usb = detect_usb_keyboard()
    if usb['connected']:
        return usb

    # Try Bluetooth
    bluetooth = detect_bluetooth_keyboard()
    if bluetooth['connected']:
        bluetooth['upload_note'] = 'To upload config, please connect via USB'
        return bluetooth

    return {
        'connected': False,
        'message': 'No keyboard detected. Please connect your keyboard via USB or Bluetooth.'
    }

if __name__ == '__main__':
    import json
    result = detect_keyboard()
    print(json.dumps(result, indent=2))
