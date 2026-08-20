#!/bin/bash
# Type text on the Android device
# Handles special characters by escaping them properly
# Supports ADBKeyboard for unicode/special char input when available
# Usage: type-text.sh [-s <serial>] [--install] <text>
#   -s <serial>  Target specific device by serial number
#   --install    Install ADBKeyboard APK from GitHub

set -e

# Parse arguments
SERIAL=""
ADB_CMD="adb"
INSTALL=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -s) SERIAL="$2"; shift 2 ;;
        --install) INSTALL=true; shift ;;
        --) shift; break ;;
        -*) echo "Usage: type-text.sh [-s <serial>] [--install] <text>"; exit 1 ;;
        *) break ;;
    esac
done

# Build ADB command with optional serial
if [ -n "$SERIAL" ]; then
    ADB_CMD="adb -s $SERIAL"
fi

# Handle --install flag
if [ "$INSTALL" = true ]; then
    APK_URL="https://github.com/nicnocquee/ADBKeyBoard/releases/download/v1.0/ADBKeyboard.apk"
    APK_PATH="/tmp/ADBKeyboard.apk"
    echo "Downloading ADBKeyboard..."
    curl -L -o "$APK_PATH" "$APK_URL" 2>/dev/null
    echo "Installing ADBKeyboard..."
    $ADB_CMD install -r "$APK_PATH"
    rm -f "$APK_PATH"
    echo "ADBKeyboard installed. Enable it in Settings > System > Languages & input > On-screen keyboard"
    echo "Then set as active: adb shell ime set com.android.adbkeyboard/.AdbIME"
    exit 0
fi

if [ $# -lt 1 ]; then
    echo "Usage: type-text.sh [-s <serial>] [--install] <text>"
    echo "Example: type-text.sh \"Hello World\""
    echo "Example: type-text.sh -s 1A051FDF6007PA \"Hello World\""
    echo "Example: type-text.sh --install  (install ADBKeyboard for better input)"
    exit 1
fi

text="$*"

# Check if ADBKeyboard is installed and use it for better unicode/special char support
if $ADB_CMD shell pm list packages 2>/dev/null | grep -q "com.android.adbkeyboard"; then
    # ADBKeyboard handles unicode, spaces, and special chars natively
    $ADB_CMD shell am broadcast -a ADB_INPUT_TEXT --es msg "$text" > /dev/null 2>&1
    echo "Typed (via ADBKeyboard): $text"
    exit 0
fi

# Fallback: standard input text with escaping
# Check if text contains only simple characters
if [[ "$text" =~ ^[a-zA-Z0-9]+$ ]]; then
    # Simple text - use input text
    $ADB_CMD shell input text "$text"
else
    # Complex text - escape special characters for shell
    # Replace spaces with %s (ADB convention)
    escaped="${text// /%s}"

    # Escape shell special characters
    escaped="${escaped//\'/\\\'}"
    escaped="${escaped//\"/\\\"}"
    escaped="${escaped//\\/\\\\}"
    escaped="${escaped//\(/\\\(}"
    escaped="${escaped//\)/\\\)}"
    escaped="${escaped//\&/\\\&}"
    escaped="${escaped//\|/\\\|}"
    escaped="${escaped//\;/\\\;}"
    escaped="${escaped//\</\\\<}"
    escaped="${escaped//\>/\\\>}"
    escaped="${escaped//\$/\\\$}"
    escaped="${escaped//\`/\\\`}"

    $ADB_CMD shell input text "$escaped"
fi

echo "Typed: $text"
