#!/bin/bash

#########################################################################
# Launch All TWS Instances
#
# Starts both TWS accounts simultaneously with automated login
# Handles existing instances based on user preference
#########################################################################

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Launching All TWS Instances${NC}"
echo -e "${BLUE}========================================${NC}\n"

IBC_DIR="$HOME/ibkr_tws/scripts"
CONFIG_DIR="$HOME/ibkr_tws/config"

# Check if IBC is installed
if [ ! -d "$IBC_DIR" ]; then
    echo -e "${RED}✗ IBC not installed. Run setup-ibc.sh first.${NC}"
    exit 1
fi

# Check for existing TWS instances
EXISTING_INSTANCES=$(ps aux | grep "Trader Workstation" | grep -v grep)

if [ ! -z "$EXISTING_INSTANCES" ]; then
    INSTANCE_COUNT=$(echo "$EXISTING_INSTANCES" | wc -l | tr -d ' ')
    echo -e "${YELLOW}⚠️  Warning: $INSTANCE_COUNT TWS instance(s) already running${NC}\n"

    # Show existing instances
    echo "Existing instances:"
    echo "$EXISTING_INSTANCES" | awk '{printf "  PID: %s - Started: %s %s\n", $2, $9, $10}'
    echo ""

    # Check command line argument for automatic behavior
    if [ "$1" = "--force" ] || [ "$1" = "-f" ]; then
        echo -e "${YELLOW}→ Force mode: Stopping existing instances...${NC}"
        $HOME/ibkr_tws/scripts/stop-all.sh
        sleep 3
    elif [ "$1" = "--skip" ] || [ "$1" = "-s" ]; then
        echo -e "${YELLOW}→ Skip mode: Launching alongside existing instances${NC}"
        echo ""
    else
        # Interactive prompt
        echo -e "${YELLOW}What would you like to do?${NC}"
        echo "  1) Stop existing and launch new instances (recommended)"
        echo "  2) Launch new instances alongside existing ones"
        echo "  3) Cancel"
        echo ""
        read -p "Enter choice [1-3]: " choice

        case $choice in
            1)
                echo -e "\n${YELLOW}→ Stopping existing instances...${NC}"
                $HOME/ibkr_tws/scripts/stop-all.sh
                sleep 3
                ;;
            2)
                echo -e "\n${YELLOW}→ Launching alongside existing instances${NC}"
                echo -e "${YELLOW}   Note: This may cause port conflicts!${NC}\n"
                ;;
            3|*)
                echo -e "\n${YELLOW}Cancelled. No changes made.${NC}"
                exit 0
                ;;
        esac
    fi
fi

# Check if ports are available
PORT_7497_IN_USE=$(lsof -i :7497 2>/dev/null)
PORT_7498_IN_USE=$(lsof -i :7498 2>/dev/null)

if [ ! -z "$PORT_7497_IN_USE" ]; then
    echo -e "${RED}✗ API Port 7497 is already in use!${NC}"
    echo "Process using port:"
    echo "$PORT_7497_IN_USE"
    echo ""
    echo "Run 'tws-stop' or '~/ibkr_tws/scripts/stop-all.sh' to stop existing instances"
    exit 1
fi

if [ ! -z "$PORT_7498_IN_USE" ]; then
    echo -e "${RED}✗ API Port 7498 is already in use!${NC}"
    echo "Process using port:"
    echo "$PORT_7498_IN_USE"
    echo ""
    echo "Run 'tws-stop' or '~/ibkr_tws/scripts/stop-all.sh' to stop existing instances"
    exit 1
fi

# Launch weng0754
echo -e "${YELLOW}→ Starting TWS for account: weng0754 (API Port 7497)${NC}"
IBC_INI="$CONFIG_DIR/weng0754/config.ini" "$IBC_DIR/tws-launch-wrapper.sh" -inline > "$HOME/ibkr_tws/logs/weng0754.log" 2>&1 &
WENG0754_PID=$!
sleep 2

# Launch weng9999
echo -e "${YELLOW}→ Starting TWS for account: weng9999 (API Port 7498)${NC}"
IBC_INI="$CONFIG_DIR/weng9999/config.ini" "$IBC_DIR/tws-launch-wrapper.sh" -inline > "$HOME/ibkr_tws/logs/weng9999.log" 2>&1 &
WENG9999_PID=$!
sleep 2

echo ""
echo -e "${GREEN}✓ Both TWS instances started${NC}\n"

echo -e "${BLUE}Process Information:${NC}"
echo -e "  weng0754: PID $WENG0754_PID (API Port 7497)"
echo -e "  weng9999: PID $WENG9999_PID (API Port 7498)"
echo ""
echo -e "${BLUE}Logs:${NC}"
echo -e "  ${YELLOW}tail -f ~/ibkr_tws/logs/weng0754.log${NC}"
echo -e "  ${YELLOW}tail -f ~/ibkr_tws/logs/weng9999.log${NC}"
echo ""
echo -e "${BLUE}Check status:${NC}"
echo -e "  ${YELLOW}~/ibkr_tws/scripts/status.sh${NC}"
echo ""
echo -e "${BLUE}To stop all:${NC}"
echo -e "  ${YELLOW}~/ibkr_tws/scripts/stop-all.sh${NC}"
echo ""
