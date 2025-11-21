#!/bin/bash

#########################################################################
# Launch TWS for weng0754
# Handles existing instances on same port
#########################################################################

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

IBC_DIR="$HOME/ibkr_tws/scripts"
CONFIG_DIR="$HOME/ibkr_tws/config"
ACCOUNT="weng0754"
API_PORT=7497

echo -e "${YELLOW}Starting TWS for account: $ACCOUNT${NC}"

# Check if port is in use
PORT_IN_USE=$(lsof -i :$API_PORT 2>/dev/null)

if [ ! -z "$PORT_IN_USE" ]; then
    echo -e "${RED}✗ API Port $API_PORT is already in use!${NC}"
    echo "Process using port:"
    echo "$PORT_IN_USE"
    echo ""

    if [ "$1" = "--force" ] || [ "$1" = "-f" ]; then
        echo -e "${YELLOW}→ Force mode: Killing process on port $API_PORT${NC}"
        PID=$(echo "$PORT_IN_USE" | awk 'NR==2 {print $2}')
        kill $PID 2>/dev/null
        sleep 2
    else
        read -p "Stop existing instance and restart? (y/N): " choice
        case $choice in
            y|Y)
                echo -e "${YELLOW}→ Stopping existing instance...${NC}"
                PID=$(echo "$PORT_IN_USE" | awk 'NR==2 {print $2}')
                kill $PID 2>/dev/null
                sleep 2
                ;;
            *)
                echo -e "${YELLOW}Cancelled${NC}"
                exit 1
                ;;
        esac
    fi
fi

# Launch TWS with IBC_INI environment variable
IBC_INI="$CONFIG_DIR/$ACCOUNT/config.ini" "$IBC_DIR/tws-launch-wrapper.sh" -inline > "$HOME/ibkr_tws/logs/$ACCOUNT.log" 2>&1 &
PID=$!

echo -e "${GREEN}✓ TWS started for $ACCOUNT (PID: $PID, API Port $API_PORT)${NC}"
echo ""
echo "Log: tail -f ~/ibkr_tws/logs/$ACCOUNT.log"
