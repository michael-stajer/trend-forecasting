#!/bin/bash
# Wait for UI transitions to complete before proceeding
# Usage: wait-for-idle.sh [-s <serial>]
#   -s <serial>  Target specific device by serial number
#
# Polls for APP_STATE_IDLE, max 30 attempts (3s timeout)
# Falls through after timeout (never blocks forever)

# Parse arguments
SERIAL=""
ADB_CMD="adb"

while getopts "s:" opt; do
    case $opt in
        s) SERIAL="$OPTARG" ;;
        *) echo "Usage: wait-for-idle.sh [-s <serial>]"; exit 1 ;;
    esac
done

# Build ADB command with optional serial
if [ -n "$SERIAL" ]; then
    ADB_CMD="adb -s $SERIAL"
fi

MAX_ATTEMPTS=30
attempt=0

while [ $attempt -lt $MAX_ATTEMPTS ]; do
    state=$($ADB_CMD shell dumpsys window -a 2>/dev/null | grep "mAppTransitionState" | head -1)

    if echo "$state" | grep -q "APP_STATE_IDLE"; then
        echo "idle=true"
        echo "UI is idle (attempt $((attempt + 1)))"
        exit 0
    fi

    sleep 0.1
    attempt=$((attempt + 1))
done

# Timeout - proceed anyway
echo "idle=timeout"
echo "Timed out waiting for idle after ${MAX_ATTEMPTS} attempts, proceeding"
exit 0
