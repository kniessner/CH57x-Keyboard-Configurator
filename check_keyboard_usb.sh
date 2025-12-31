#!/bin/bash

# Script to check if CH57x keyboard is connected
# Compatible keyboards have vendor ID 0x1189 (4489 in decimal)

echo "🔍 Checking for CH57x compatible keyboard..."
echo "================================================"
echo ""

# Get USB device information
usb_info=$(system_profiler SPUSBDataType 2>/dev/null)

# Check for vendor ID 1189 (0x1189)
if echo "$usb_info" | grep -i "Vendor ID: 0x1189" > /dev/null 2>&1; then
    echo "✅ CH57x keyboard detected!"
    echo ""
    echo "Device details:"
    echo "$usb_info" | grep -A 10 "Vendor ID: 0x1189" | grep -E "(Product ID:|Vendor ID:|Serial Number:|Location ID:)"
    echo ""
    echo "Your keyboard is compatible with ch57x-keyboard-tool!"
    exit 0
else
    echo "❌ No CH57x keyboard found (Vendor ID 0x1189)"
    echo ""
    echo "All connected USB devices:"
    echo "$usb_info" | grep -E "Product ID:|Vendor ID:" | head -20
    echo ""
    echo "Please make sure:"
    echo "  1. The keyboard is plugged in"
    echo "  2. You're using a data-capable USB cable (not charge-only)"
    echo "  3. Try a different USB port"
    exit 1
fi
