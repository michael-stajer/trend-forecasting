#!/bin/bash
# Detect and dismiss the soft keyboard if visible
# Usage: dismiss-keyboard.sh [-s <serial>]
#   -s <serial>  Target specific device by serial number
#
# Outputs keyboard_was_visible=true|false

# Parse arguments
SERIAL=""
ADB_CMD="adb"

while getopts "s:" opt; do
    case $opt in
        s) SERIAL="$OPTARG" ;;
        *) echo "Usage: dismiss-keyboard.sh [-s <serial>]"; exit 1 ;;
    esac
done

# Build ADB command with optional serial
if [ -n "$SERIAL" ]; then
    ADB_CMD="adb -s $SERIAL"
fi

# Check if keyboard is visible
result=$($ADB_CMD shell dumpsys input_method 2>/dev/null | grep "mInputShown=true")

if [ -n "$result" ]; then
    # Keyboard is visible, dismiss with BACK key
    $ADB_CMD shell input keyevent 4

    # Wait for dismiss animation
    sleep 0.3

    # Verify dismissed
    verify=$($ADB_CMD shell dumpsys input_method 2>/dev/null | grep "mInputShown=true")
    if [ -z "$verify" ]; then
        echo "keyboard_was_visible=true"
        echo "Keyboard dismissed successfully"
    else
        echo "keyboard_was_visible=true"
        echo "Warning: keyboard may still be visible"
    fi
else
    echo "keyboard_was_visible=false"
    echo "No keyboard to dismiss"
fi
