#!/bin/bash

# Script to upload test configuration to identify button positions
# Each button will type its index number

set -e

MAIN_CONFIG="keyboard_config.yaml"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/common.sh"

print_header "Keyboard Button Test Mode"
cd_project_root
ensure_ch57x_tool
require_keyboard_connected

echo "✅ Keyboard detected"
echo ""

echo "📋 Test Configuration Layout:"
echo ""
echo "  Physical Buttons (3 rows × 4 columns):"
echo "  ┌───┬───┬───┬───┐"
echo "  │ 1 │ 2 │ 3 │ 4 │  Row 1"
echo "  ├───┼───┼───┼───┤"
echo "  │ 5 │ 6 │ 7 │ 8 │  Row 2"
echo "  ├───┼───┼───┼───┤"
echo "  │ 9 │ 0 │ - │ = │  Row 3 (10=0, 11=-, 12==)"
echo "  └───┴───┴───┴───┘"
echo ""
echo "  🎚️ Knob 1: Press=k, Left=[, Right=]"
echo "  🎚️ Knob 2: Press=l, Left=,, Right=."
echo ""

TEMP_CONFIG="$(mktemp "${TMPDIR:-/tmp}/keyboard_test_config.XXXXXX.yaml")"
trap 'rm -f "$TEMP_CONFIG"' EXIT

cat > "$TEMP_CONFIG" <<'EOF'
orientation: normal
rows: 3
columns: 4
knobs: 2
layers:
  - buttons:
      - ["1", "2", "3", "4"]
      - ["5", "6", "7", "8"]
      - ["9", "0", "minus", "equal"]
    knobs:
      - ccw: leftbracket
        press: k
        cw: rightbracket
      - ccw: comma
        press: l
        cw: dot
EOF

echo "🔍 Validating test configuration..."
if ! validate_yaml_file "$TEMP_CONFIG" > /dev/null 2>&1; then
    echo "❌ Test configuration is invalid"
    exit 1
fi

echo "✅ Test configuration is valid"
echo ""

echo "⚠️  This will temporarily replace your current keyboard config."
echo "Press each button to see which number it types."
echo ""

# Backup current config
if [ -f "$MAIN_CONFIG" ]; then
    echo "📦 Creating backup of your main config..."
    backup_file="$(create_timestamped_backup "$MAIN_CONFIG")"
    echo "   $backup_file"
    echo ""
fi

# Ask for confirmation
read -p "Upload test configuration? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "❌ Test cancelled"
    exit 0
fi

echo ""
echo "🚀 Uploading test configuration..."
echo "⚠️  You'll be prompted for your password (sudo required)"
echo ""

# Upload test configuration
if upload_yaml_file "$TEMP_CONFIG"; then
    echo ""
    echo "✅ Test configuration uploaded!"
    echo ""
    echo "📝 Testing Instructions:"
    echo "  1. Open a text editor or terminal"
    echo "  2. Press each button on your keyboard"
    echo "  3. Note which numbers appear for each physical button"
    echo "  4. Test knobs: press and rotate them"
    echo ""
    echo "Expected output:"
    echo "  • Buttons should type: 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, -, ="
    echo "  • Knob 1 press: k, rotate: [ or ]"
    echo "  • Knob 2 press: l, rotate: , or ."
    echo ""
    echo "🔄 When done testing, restore your main config:"
    echo "   ./keyboard.sh upload"
    echo ""
else
    echo ""
    echo "❌ Upload failed"
    exit 1
fi
