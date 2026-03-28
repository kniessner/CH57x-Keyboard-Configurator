#!/bin/bash

# Script to check if CH57x keyboard is connected
# Compatible keyboards are expected to expose USB vendor ID 0x1189.

echo "🔍 Checking for CH57x compatible keyboard..."
echo "================================================"
echo ""

if command -v system_profiler >/dev/null 2>&1; then
    usb_info=$(system_profiler SPUSBDataType 2>/dev/null)

    if echo "$usb_info" | grep -i "Vendor ID: 0x1189" >/dev/null 2>&1; then
        echo "✅ CH57x keyboard detected!"
        echo ""
        echo "Device details:"
        echo "$usb_info" | grep -A 10 "Vendor ID: 0x1189" | grep -E "(Product ID:|Vendor ID:|Serial Number:|Location ID:)"
        echo ""
        echo "Your keyboard is compatible with ch57x-keyboard-tool!"
        exit 0
    fi

    echo "❌ No CH57x keyboard found (Vendor ID 0x1189)"
    echo ""
    echo "All connected USB devices:"
    echo "$usb_info" | grep -E "Product ID:|Vendor ID:" | head -20
elif command -v lsusb >/dev/null 2>&1; then
    usb_info=$(lsusb 2>/dev/null)

    if echo "$usb_info" | grep -i "ID 1189:" >/dev/null 2>&1; then
        echo "✅ CH57x-compatible USB device detected!"
        echo ""
        echo "Device details:"
        echo "$usb_info" | grep -i "ID 1189:"
        echo ""
        echo "Your keyboard should be compatible with ch57x-keyboard-tool."
        exit 0
    fi

    echo "❌ No CH57x keyboard found (Vendor ID 0x1189)"
    echo ""
    echo "All connected USB devices:"
    echo "$usb_info" | head -20
else
    echo "❌ No supported USB inspection tool found"
    echo ""
    echo "Install either:"
    echo "  - macOS: system_profiler"
    echo "  - Linux: lsusb (usbutils package)"
    exit 1
fi

echo ""
echo "Please make sure:"
echo "  1. The keyboard is plugged in"
echo "  2. You're using a data-capable USB cable (not charge-only)"
echo "  3. Try a different USB port"
exit 1
