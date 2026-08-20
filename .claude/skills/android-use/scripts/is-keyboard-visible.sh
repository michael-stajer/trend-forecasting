#!/bin/bash
# Check if the soft keyboard is currently visible
# Usage: is-keyboard-visible.sh [-s <serial>]
#   -s <serial>  Target specific device by serial number
#
# Exit code 0 = keyboard visible, 1 = keyboard hidden

# Parse arguments
SERIAL=""
ADB_CMD="adb"

while getopts "s:" opt; do
    case $opt in
        s) SERIAL="$OPTARG" ;;
        *) echo "Usage: is-keyboard-visible.sh [-s <serial>]"; exit 1 ;;
    esac
done

# Build ADB command with optional serial
if [ -n "$SERIAL" ]; then
    ADB_CMD="adb -s $SERIAL"
fi

# Check keyboard visibility via input method service
result=$($ADB_CMD shell dumpsys input_method 2>/dev/null | grep "mInputShown=true")

if [ -n "$result" ]; then
    echo "keyboard_visible=true"
    exit 0
else
    echo "keyboard_visible=false"
    exit 1
fi
