#!/bin/bash
# Dump the current UI hierarchy (accessibility tree) from the Android device
# Usage: get-screen.sh [-s <serial>]
#   -s <serial>  Target specific device by serial number

set -e

# Parse arguments
SERIAL=""
ADB_CMD="adb"

while getopts "s:" opt; do
    case $opt in
        s) SERIAL="$OPTARG" ;;
        *) echo "Usage: get-screen.sh [-s <serial>]"; exit 1 ;;
    esac
done

# Build ADB command with optional serial
if [ -n "$SERIAL" ]; then
    ADB_CMD="adb -s $SERIAL"
fi

# Fast path: stream XML directly via exec-out (avoids device temp file + pull)
xml=$($ADB_CMD exec-out uiautomator dump /dev/tty 2>/dev/null || true)

# Strip the trailing "UI hierrchy dumped to: /dev/tty" message (note: Android has a typo in "hierrchy")
xml=$(echo "$xml" | sed 's/UI hierrchy dumped to: \/dev\/tty$//' | sed 's/UI hierarchy dumped to: \/dev\/tty$//')

if [ -n "$xml" ] && echo "$xml" | grep -q "<hierarchy"; then
    echo "$xml"
    exit 0
fi

# Fallback: classic 3-step method (write to device, pull, cleanup)
DEVICE_PATH="/sdcard/window_dump.xml"
LOCAL_PATH="/tmp/android_ui_dump.xml"

$ADB_CMD shell uiautomator dump "$DEVICE_PATH" > /dev/null 2>&1
$ADB_CMD pull "$DEVICE_PATH" "$LOCAL_PATH" > /dev/null 2>&1
$ADB_CMD shell rm -f "$DEVICE_PATH" > /dev/null 2>&1

cat "$LOCAL_PATH"
