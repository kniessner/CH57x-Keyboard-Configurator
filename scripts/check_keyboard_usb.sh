#!/bin/bash

# Script to check if CH57x keyboard is connected
# Compatible keyboards have vendor ID 0x1189 (4489 in decimal)

CH57X_VENDOR_HEX="0x1189"
CH57X_VENDOR_DEC="4489"

echo "🔍 Checking for CH57x compatible keyboard..."
echo "================================================"
echo ""

# Try system_profiler first. On some macOS setups it returns an empty USB list,
# so we fall back to ioreg below.
usb_info=$(system_profiler SPUSBDataType 2>/dev/null)

if echo "$usb_info" | grep -i "Vendor ID: $CH57X_VENDOR_HEX" > /dev/null 2>&1; then
    echo "✅ CH57x keyboard detected!"
    echo ""
    echo "Device details (system_profiler):"
    echo "$usb_info" | grep -A 10 "Vendor ID: $CH57X_VENDOR_HEX" | grep -E "(Product ID:|Vendor ID:|Serial Number:|Location ID:)"
    echo ""
    echo "Your keyboard is compatible with ch57x-keyboard-tool!"
    exit 0
fi

ioreg_info=$(ioreg -p IOUSB -l -w 0 2>/dev/null)

if echo "$ioreg_info" | grep -q "\"idVendor\" = $CH57X_VENDOR_DEC"; then
    echo "✅ CH57x keyboard detected!"
    echo ""
    echo "Device details (ioreg fallback):"
    echo "$ioreg_info" | grep -B 20 -A 20 "\"idVendor\" = $CH57X_VENDOR_DEC" | grep -E 'USB Product Name|idProduct|idVendor|USB Serial Number|locationID'
    echo ""
    echo "Your keyboard is compatible with ch57x-keyboard-tool!"
    exit 0
fi

echo "❌ No CH57x keyboard found (Vendor ID $CH57X_VENDOR_HEX / $CH57X_VENDOR_DEC)"
echo ""
if [ -n "$usb_info" ]; then
    echo "USB devices from system_profiler:"
    echo "$usb_info" | grep -E "Product ID:|Vendor ID:" | head -20
    echo ""
fi
echo "Please make sure:"
echo "  1. The keyboard is plugged in"
echo "  2. You're using a data-capable USB cable (not charge-only)"
echo "  3. Try a different USB port"
exit 1
