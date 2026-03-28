#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ $# -eq 0 ]; then
    exec "$SCRIPT_DIR/scripts/run_tui.sh"
fi

exec "$SCRIPT_DIR/scripts/manage.sh" "$@"
