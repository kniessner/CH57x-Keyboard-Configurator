#!/bin/bash

set -euo pipefail

# Force Chromium onto the X11 backend and prefer desktop GL so it can
# bypass the current Wayland GPU fallback on this machine.
unset WAYLAND_DISPLAY
export OZONE_PLATFORM=x11

exec chromium --ozone-platform=x11 --use-gl=desktop "$@"
