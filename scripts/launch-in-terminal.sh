#!/bin/bash

#########################################################################
# Launch TWS with IBC in Terminal (shows errors)
#########################################################################

# Use AppleScript to open Terminal and run the command
osascript <<EOF
tell application "Terminal"
    activate
    do script "cd ~/ibkr_tws/scripts && /opt/ibc/twsstartmacos.sh ~/ibkr_tws/config/weng0754/config.ini"
end tell
EOF

echo "Launching TWS in Terminal window..."
echo "Watch the Terminal window for IBC output and any errors"
