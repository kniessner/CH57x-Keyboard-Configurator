#!/bin/bash

# Script to validate keyboard configuration without uploading

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/common.sh"

print_header "Keyboard Configuration Validator"

cd_project_root
require_file "$CONFIG_FILE"
ensure_ch57x_tool

echo "📄 Validating: $CONFIG_FILE"
echo ""

# Validate configuration
if validate_yaml_file "$CONFIG_FILE"; then
    echo ""
    echo "✅ Configuration is valid!"
    echo ""
    echo "You can now upload it with:"
    echo "  ./keyboard.sh upload"
    exit 0
else
    echo ""
    echo "❌ Configuration has errors"
    echo ""
    echo "Common issues:"
    echo "  - Incorrect key names (use 'ch57x-keyboard-tool show-keys')"
    echo "  - Wrong YAML syntax (check indentation)"
    echo "  - Invalid modifier combinations"
    echo ""
    echo "Fix the errors in $CONFIG_FILE and try again"
    exit 1
fi
