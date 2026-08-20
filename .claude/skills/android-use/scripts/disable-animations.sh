#!/bin/bash
# Disable or restore device animations for faster, more deterministic automation
# Usage: disable-animations.sh [-s <serial>] [--restore]
#   -s <serial>  Target specific device by serial number
#   --restore    Restore animations to default (1.0)

# Parse arguments
SERIAL=""
ADB_CMD="adb"
RESTORE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -s) SERIAL="$2"; shift 2 ;;
        --restore) RESTORE=true; shift ;;
        *) echo "Usage: disable-animations.sh [-s <serial>] [--restore]"; exit 1 ;;
    esac
done

# Build ADB command with optional serial
if [ -n "$SERIAL" ]; then
    ADB_CMD="adb -s $SERIAL"
fi

if [ "$RESTORE" = true ]; then
    $ADB_CMD shell settings put global window_animation_scale 1.0
    $ADB_CMD shell settings put global transition_animation_scale 1.0
    $ADB_CMD shell settings put global animator_duration_scale 1.0
    echo "Animations restored to 1.0"
else
    $ADB_CMD shell settings put global window_animation_scale 0
    $ADB_CMD shell settings put global transition_animation_scale 0
    $ADB_CMD shell settings put global animator_duration_scale 0
    echo "Animations disabled (set to 0)"
fi
