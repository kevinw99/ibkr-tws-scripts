#!/bin/bash

#########################################################################
# Auto-login TWS using AppleScript and Keychain
# Fills credentials automatically, you just click login and approve 2FA
#########################################################################

ACCOUNT="${1:-weng0754}"
TRADING_MODE="${2:-live}"

echo "Launching TWS for $ACCOUNT..."

# Get password from Keychain
PASSWORD=$(security find-generic-password -a "$ACCOUNT" -s "IBKR_TWS" -w 2>/dev/null)

if [ -z "$PASSWORD" ]; then
    echo "Error: Credentials not found in Keychain for $ACCOUNT"
    echo "Run: ~/ibkr_tws/scripts/save-credentials.sh"
    exit 1
fi

# Launch TWS
open -n "/Users/kweng/Applications/Trader Workstation 10.37/Trader Workstation 10.37-1.app"

# Wait for login window to appear
sleep 5

# Auto-fill credentials using AppleScript
osascript <<EOF
tell application "System Events"
    repeat until (exists window "Login" of application process "JavaApplicationStub")
        delay 0.5
    end repeat
    
    tell window "Login" of application process "JavaApplicationStub"
        -- Fill username
        set value of text field 1 to "$ACCOUNT"
        delay 0.3
        
        -- Fill password  
        set value of text field 2 to "$PASSWORD"
        delay 0.3
        
        -- Select trading mode
        if "$TRADING_MODE" is "paper" then
            click radio button "Paper Trading" of radio group 1
        else
            click radio button "Live Trading" of radio group 1
        end if
    end tell
end tell
EOF

echo "✓ Credentials filled!"
echo "→ Click 'Log In' button in TWS"
echo "→ Approve 2FA on your phone"

