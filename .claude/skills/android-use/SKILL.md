---
name: android-use
description: Control an Android device over ADB - tap, swipe, type, launch apps, screenshot. Also a real mobile BROWSER surface: drive Chrome on the phone when you need a browser or a genuine mobile web session. A live Pixel 9 Pro is reachable over Tailscale from the mac mini (see references/adb-reference.md).
compatibility: darwin, linux
---

# Android Device Control Skill

This skill enables you to control Android devices connected via ADB (Android Debug Bridge). You act as both the reasoning and execution engine - reading the device's UI state directly and deciding what actions to take.

## Prerequisites

- Android device connected via USB with USB debugging enabled
- ADB installed and accessible in PATH (`brew install android-platform-tools`)
- Device authorized for debugging (accepted the "Allow USB debugging?" prompt)

## Before You Start

For faster, more reliable automation, run these once per device session:

```bash
# Disable animations (makes actions faster and more deterministic)
scripts/disable-animations.sh [-s serial]

# Set screen timeout to 2+ minutes (prevents screen going dark during automation)
adb -s [serial] shell settings put system screen_off_timeout 120000

# Install ADBKeyboard for better text input (handles unicode, spaces, special chars)
scripts/type-text.sh --install
# Then on device: Settings > System > Languages & input > enable ADBKeyboard
# Set active: adb shell ime set com.android.adbkeyboard/.AdbIME
```

## Standard Device Preamble

**Every Android skill must run this preamble before doing anything else.** This ensures the device is awake, unlocked, and ready for automation.

1. **Check device connection** — Run `scripts/check-device.sh`. Note the serial.
2. **Wake the device** — Run `scripts/wake.sh [-s serial]`
3. **Check for lock screen** — Run `scripts/get-screen.sh [-s serial]` and look for lock screen indicators:
   - `keyguard_pin_view` or `keyguard` in the UI XML → PIN lock
   - `com.android.systemui` as the foreground activity with no app content → lock screen
   - `StatusBar` with `bouncer` → lock screen
4. **Unlock if locked** — Enter PIN from `.env` and press Enter:
   ```bash
   PIN=$ADB_DEVICE_PIN
   adb -s [serial] shell input text $PIN
   adb -s [serial] shell input keyevent 66
   ```
   Then wait 2s and verify unlock succeeded by checking the activity again.
5. **Disable animations** — Run `scripts/disable-animations.sh [-s serial]`
6. **Proceed** with the skill's actual workflow.

**If the lock screen is encountered at any point during a run** (device re-locked due to timeout), repeat steps 2–4 and then **retry the interrupted step** — do not abort the run.

## Multi-Device Support

All scripts support the `-s <serial>` flag to target a specific device. This is essential when multiple devices are connected (e.g., a physical phone AND an emulator).

### Identifying Devices

Run `scripts/check-device.sh` to see all connected devices:

```
Multiple devices connected (2):

  [PHYSICAL] 1A051FDF6007PA - Pixel 6
  [EMULATOR] emulator-5554 - sdk_gphone64_arm64

Use -s <serial> to specify which device to use.
```

### Choosing the Right Device

When the user mentions:
- **"phone"**, **"my phone"**, **"physical device"** -> Use the `[PHYSICAL]` device
- **"emulator"**, **"virtual device"**, **"AVD"** -> Use the `[EMULATOR]` device
- If unclear, **ask the user** which device they want to target

### Using the Serial Flag

Once you identify the target device, pass `-s <serial>` to ALL subsequent scripts:

```bash
scripts/check-device.sh -s 1A051FDF6007PA
scripts/get-screen.sh -s 1A051FDF6007PA
scripts/tap.sh -s 1A051FDF6007PA 540 960
```

**Important:** Be consistent - use the same serial for all commands in a session.

## Core Workflow

When given a task, follow this perception-action loop:

1. **Check device connection** - Run `scripts/check-device.sh` first
   - If multiple devices: identify target based on user intent or ask
   - Note the serial number for subsequent commands
2. **Disable animations** - Run `scripts/disable-animations.sh` (once per session)
3. **Get current screen state** - Run `scripts/get-screen.sh [-s serial]` to dump UI hierarchy
4. **Analyze the XML** - Read the accessibility tree to understand what's on screen
5. **Decide next action** - Based on goal + current state, choose an action
6. **Execute action** - Run the appropriate script with `-s serial` if needed
7. **Wait for idle** - Run `scripts/wait-for-idle.sh` after navigation/transitions
8. **Repeat** - Go back to step 3 until goal is achieved

## MCP Tools (Alternative Interface)

The ADB MCP server provides the same capabilities as these scripts. Use whichever is more convenient:

### Device Management
- `adb_connect` - Connect to device via TCP/IP
- `adb_list_devices` - List all connected devices
- `adb_get_device_info` - Get device manufacturer, model, Android version

### Screen Operations
- `adb_capture_screen` - Take screenshot (returns base64 PNG)
- `adb_get_ui_hierarchy` - Dump UI accessibility tree (XML)
- `adb_get_current_activity` - Get current foreground app

### Input Operations
- `adb_tap` - Tap at screen coordinates (x, y)
- `adb_swipe` - Swipe gesture (x1, y1, x2, y2, duration)
- `adb_type` - Type text (auto-uses ADBKeyboard if installed)
- `adb_press_key` - Press key by keycode (HOME=3, BACK=4, MENU=82, POWER=26)

### Keyboard & UI
- `adb_is_keyboard_visible` - Check if soft keyboard is showing
- `adb_dismiss_keyboard` - Dismiss keyboard if visible
- `adb_wait_for_idle` - Wait for UI transitions to complete

### Automation Setup
- `adb_disable_animations` - Disable device animations
- `adb_restore_animations` - Restore animations to default

### App Management
- `adb_launch_app` - Launch app by package name
- `adb_force_stop_app` - Force stop app
- `adb_list_apps` - List installed packages

### Advanced
- `adb_shell` - Execute arbitrary shell command (use with caution)

## Reading UI XML

The `get-screen.sh` script outputs Android's accessibility XML. Key attributes to look for:

```xml
<node index="0" text="Settings" resource-id="com.android.settings:id/title"
      class="android.widget.TextView" content-desc=""
      bounds="[42,234][1038,345]" clickable="true" />
```

**Important attributes:**
- `text` - Visible text on the element
- `content-desc` - Accessibility description (useful for icons)
- `resource-id` - Unique identifier for the element
- `bounds` - Screen coordinates as `[left,top][right,bottom]`
- `clickable` - Whether element responds to taps
- `scrollable` - Whether element can be scrolled
- `focused` - Whether element has input focus

**Calculating tap coordinates:**
From `bounds="[left,top][right,bottom]"`, calculate center:
- x = (left + right) / 2
- y = (top + bottom) / 2

Example: `bounds="[42,234][1038,345]"` -> tap at x=540, y=289

## Available Scripts

All scripts are in the `scripts/` directory. Run them via bash.

**All scripts support `-s <serial>` to target a specific device.**

### Device Management
| Script | Args | Description |
|--------|------|-------------|
| `check-device.sh` | `[-s serial]` | List devices / verify connection |
| `wake.sh` | `[-s serial]` | Wake device and dismiss lock screen |
| `screenshot.sh` | `[-s serial]` | Capture screen image |
| `disable-animations.sh` | `[-s serial] [--restore]` | Disable/restore device animations |

### Screen Reading
| Script | Args | Description |
|--------|------|-------------|
| `get-screen.sh` | `[-s serial]` | Dump UI accessibility tree |

### Input Actions
| Script | Args | Description |
|--------|------|-------------|
| `tap.sh` | `[-s serial] x y` | Tap at coordinates |
| `type-text.sh` | `[-s serial] [--install] "text"` | Type text (uses ADBKeyboard if available) |
| `swipe.sh` | `[-s serial] direction` | Swipe up/down/left/right |
| `key.sh` | `[-s serial] keyname` | Press key (home/back/enter/recent) |

### Keyboard Management
| Script | Args | Description |
|--------|------|-------------|
| `is-keyboard-visible.sh` | `[-s serial]` | Check if keyboard is showing (exit 0=yes, 1=no) |
| `dismiss-keyboard.sh` | `[-s serial]` | Dismiss keyboard if visible |

### UI Synchronization
| Script | Args | Description |
|--------|------|-------------|
| `wait-for-idle.sh` | `[-s serial]` | Wait for UI transitions to complete (3s timeout) |

### App Management
| Script | Args | Description |
|--------|------|-------------|
| `launch-app.sh` | `[-s serial] package_or_name` | Launch app by package or search by name |
| `install-apk.sh` | `[-s serial] path/to/file.apk` | Install APK to device |

## Action Guidelines

### When to tap
- Target clickable elements
- Always calculate center from bounds
- Prefer elements with `clickable="true"`

### When to type
- After tapping a text input field
- The field should have `focused="true"` or `class="android.widget.EditText"`
- Clear existing text first if needed (select all + delete)
- Dismiss keyboard with `dismiss-keyboard.sh` before reading screen (keyboard covers UI elements)

### When to swipe
- To scroll lists or pages
- To navigate between screens (e.g., swipe left/right for tabs)
- Directions: `up` (scroll down), `down` (scroll up), `left`, `right`

### When to use keys
- `home` - Return to home screen
- `back` - Go back / close dialogs
- `enter` - Submit forms / confirm
- `recent` - Open recent apps

### When to take screenshots
- For visual debugging when XML doesn't capture enough info
- To verify visual state (colors, images, etc.)
- When the task requires visual confirmation

### When to wake the device
- Before starting any task (device may have gone to sleep)
- If `get-screen.sh` returns empty or minimal XML
- If actions don't seem to be working (screen may be off)
- If PIN lock screen appears, unlock using the PIN from `.env` (see Unlocking the Device section)

### When to wait for idle
- After launching an app
- After navigating to a new screen
- After dismissing a dialog
- Before reading the screen state after any transition

## Common Patterns

### Opening an app
```bash
scripts/launch-app.sh com.android.chrome
scripts/wait-for-idle.sh
scripts/get-screen.sh
```

### Tapping a button
1. Get screen: `scripts/get-screen.sh`
2. Find element with matching text/content-desc
3. Calculate center from bounds
4. Tap: `scripts/tap.sh 540 289`

### Entering text in a field
1. Tap the text field to focus it
2. Check keyboard: `scripts/is-keyboard-visible.sh`
3. Type: `scripts/type-text.sh "your text here"`
4. Press enter if needed: `scripts/key.sh enter`

### Reading screen after typing
1. Dismiss keyboard first: `scripts/dismiss-keyboard.sh`
2. Then read: `scripts/get-screen.sh`

### Scrolling to find content
1. Get screen to check if target is visible
2. If not found, swipe: `scripts/swipe.sh up`
3. Wait: `scripts/wait-for-idle.sh`
4. Get screen again, repeat until found or reached end

### Handling dialogs/popups
- Look for elements with text like "OK", "Allow", "Accept", "Cancel"
- Tap the appropriate button
- Or press back to dismiss: `scripts/key.sh back`

## Error Handling

### No device connected
- Check USB connection
- Verify USB debugging is enabled
- Run `adb devices` manually to troubleshoot

### Element not found
- The UI may have changed - get fresh screen dump
- Try scrolling to find the element
- Element might be in a different screen/state
- Keyboard may be covering it - dismiss first

### Action didn't work
- Wait for idle after actions: `scripts/wait-for-idle.sh`
- Verify coordinates are correct
- Check if a popup/dialog appeared

### App not responding
- Press home and reopen the app
- Or force close and restart

## Setup: Wireless Connection (Tailscale)

For wireless ADB over Tailscale network:

1. Enable USB debugging on Android
2. Connect via USB once
3. Enable TCP/IP mode: `adb tcpip 5555`
4. Get device Tailscale IP from Tailscale admin console
5. Connect: `adb connect <tailscale-ip>:5555`
6. Verify: `adb devices`

## Common Package Names

- Chrome: `com.android.chrome`
- Instagram: `com.instagram.android`
- WhatsApp: `com.whatsapp`
- YouTube: `com.google.android.youtube`
- Gmail: `com.google.android.gm`
- Maps: `com.google.android.apps.maps`
- DoorDash: `com.dd.doordash`

## Tips

- **Disable animations** - Run `disable-animations.sh` at start for reliability
- **Install ADBKeyboard** - Run `type-text.sh --install` for better text input
- **Dismiss keyboard before reading** - Keyboard hides UI elements from `get-screen.sh`
- **Wait for idle** - Use `wait-for-idle.sh` after transitions
- **Be patient** - Android UI can be slow, wait between actions
- **Read carefully** - The XML tells you exactly what's on screen
- **Check your work** - Get screen after each action to verify state
- **Use screenshots** - When XML doesn't give enough context
- **Start simple** - Break complex tasks into small steps
- **Multi-device** - Always check for multiple devices first; ask user if target is unclear
- **Consistent serial** - Once you pick a device, use `-s <serial>` on ALL commands

## Using the phone as a browser

This is a real mobile browser surface. When you need a browser — especially a genuine mobile / Android session, a real Chrome on real hardware, or a site that blocks headless/automated browsers — drive Chrome on the Pixel instead of (or alongside) the mini's headless browser-host.

Open a URL:
```
adb shell am start -a android.intent.action.VIEW -d 'https://example.com' com.android.chrome
```
Then read the page with a screenshot (`screencap`) and act with taps/swipes/`input text`. See `references/adb-reference.md` for the Tailscale connection details (run adb from the mac mini; `ANDROID_SERIAL=100.110.20.60:5555`).

Sibling browser surface: the mac mini's headless Chrome (browser-host, CDP on :9223) — use that for scripted/CDP automation; use this Pixel for a real on-device mobile browser.
