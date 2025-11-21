#!/bin/bash

#########################################################################
# Auto-login TWS - Direct approach with auto-click login
# Usage: tws-auto-v2.sh [account|both] [--force]
#########################################################################

# Check for --force and --skip-check flags
FORCE_RESTART=false
SKIP_CHECK=false
for arg in "$@"; do
    if [ "$arg" = "--force" ]; then
        FORCE_RESTART=true
    fi
    if [ "$arg" = "--skip-check" ]; then
        SKIP_CHECK=true
    fi
done

# If called with "both", launch both accounts
if [ "$1" = "both" ]; then
    echo "🚀 Launching both TWS accounts..."

    # Always kill existing instances when launching both (can't prompt when backgrounded)
    TWS_COUNT=$(ps aux | grep -i "JavaApplicationStub" | grep -v grep | wc -l | tr -d ' ')

    if [ "$TWS_COUNT" -gt 0 ]; then
        echo "⚠️  Found $TWS_COUNT TWS instance(s) already running"
        echo "Stopping existing TWS instances..."
        pkill -f "JavaApplicationStub"
        sleep 2
    fi

    echo ""

    # Launch both accounts directly (no duplicate check needed since we just handled it)
    $0 weng0754 --skip-check &
    FIRST_PID=$!

    # Wait for first instance to fully start and complete login
    sleep 15

    # Launch second account
    $0 weng9999 --skip-check &
    SECOND_PID=$!

    echo ""
    echo "✓ Both accounts launching:"
    echo "  - weng0754 (PID: $FIRST_PID)"
    echo "  - weng9999 (PID: $SECOND_PID)"
    echo ""
    echo "Monitor with: ~/ibkr_tws/scripts/status.sh"

    wait
    exit 0
fi

ACCOUNT="${1:-weng0754}"
PASSWORD="eeee5555"

if [ "$ACCOUNT" = "weng9999" ]; then
    PASSWORD="nnnn9999"
fi

# Check if TWS is already running (unless --skip-check is used)
# Note: We allow multiple instances (for different accounts), so we don't block on existing processes
# This check is here for future use if needed, but currently does nothing
if [ "$SKIP_CHECK" = false ]; then
    # Allow multiple instances - no blocking
    # Each account can run simultaneously
    :
fi

echo "Launching TWS for $ACCOUNT..."
echo "Credentials will be auto-filled and login clicked automatically..."

# Launch TWS
open -n "/Users/kweng/Applications/Trader Workstation 10.37/Trader Workstation 10.37-1.app"

# Wait for the login window to be fully loaded
echo "Waiting for login window (10 seconds)..."
sleep 5

# Try to auto-fill and auto-click login using AppleScript
RESULT=$(osascript 2>&1 <<EOF
try
    -- Activate the TWS application
    tell application "/Users/kweng/Applications/Trader Workstation 10.37/Trader Workstation 10.37-1.app"
        activate
    end tell

    delay 1

    -- Type the credentials
    tell application "System Events"
        keystroke "$ACCOUNT"
        delay 0.5
        keystroke tab
        delay 0.5
        keystroke "$PASSWORD"
        delay 0.5
        keystroke return
    end tell

    return "Success"
on error errMsg
    return "Error: " & errMsg
end try
EOF
)

echo "$RESULT"

# Check if the output contains "Error" (osascript exit code is 0 even on errors)
if echo "$RESULT" | grep -q "^Error"; then
    echo ""
    echo "⚠️  $RESULT"
    echo ""
    echo "Troubleshooting:"
    echo "1. Make sure TWS login window is visible"
    echo "2. Check System Preferences → Privacy & Security → Accessibility"
    echo "3. Add 'Terminal' or 'iTerm' to allowed apps"
    echo ""
    echo "Manual credentials:"
    echo "  Username: $ACCOUNT"
    echo "  Password: [see script]"
else
    echo "✓ Credentials auto-filled and login clicked!"
    echo "→ Approve 2FA on your phone"
    echo "→ Account: $ACCOUNT"
fi

