#!/bin/bash

#########################################################################
# Show Status of TWS Instances
#########################################################################

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}TWS Instance Status${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Check for running TWS processes
TWS_PROCESSES=$(ps aux | grep "Trader Workstation" | grep -v grep)

if [ -z "$TWS_PROCESSES" ]; then
    echo -e "${RED}✗ No TWS instances running${NC}\n"
else
    echo -e "${GREEN}✓ Running TWS instances:${NC}\n"
    echo "$TWS_PROCESSES" | awk '{printf "  PID: %s - CPU: %s%% - MEM: %s%% - Started: %s %s\n", $2, $3, $4, $9, $10}'
    echo ""

    # Count instances
    INSTANCE_COUNT=$(echo "$TWS_PROCESSES" | wc -l | tr -d ' ')
    echo -e "${YELLOW}Total instances: $INSTANCE_COUNT${NC}\n"
fi

# Check API ports
echo -e "${BLUE}API Port Status:${NC}"
if lsof -i :7497 > /dev/null 2>&1; then
    echo -e "  Port 7497: ${GREEN}ACTIVE${NC} (weng0754)"
else
    echo -e "  Port 7497: ${RED}INACTIVE${NC} (weng0754)"
fi

if lsof -i :7498 > /dev/null 2>&1; then
    echo -e "  Port 7498: ${GREEN}ACTIVE${NC} (weng9999)"
else
    echo -e "  Port 7498: ${RED}INACTIVE${NC} (weng9999)"
fi

echo ""

# Check log files
echo -e "${BLUE}Recent Log Activity:${NC}"
LOG_DIR="$HOME/ibkr_tws/logs"

if [ -f "$LOG_DIR/weng0754.log" ]; then
    LAST_UPDATE=$(stat -f "%Sm" "$LOG_DIR/weng0754.log")
    echo -e "  weng0754: Last updated ${YELLOW}$LAST_UPDATE${NC}"
else
    echo -e "  weng0754: ${RED}No log file${NC}"
fi

if [ -f "$LOG_DIR/weng9999.log" ]; then
    LAST_UPDATE=$(stat -f "%Sm" "$LOG_DIR/weng9999.log")
    echo -e "  weng9999: Last updated ${YELLOW}$LAST_UPDATE${NC}"
else
    echo -e "  weng9999: ${RED}No log file${NC}"
fi

echo ""
