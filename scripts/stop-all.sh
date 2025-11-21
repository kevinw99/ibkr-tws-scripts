#!/bin/bash

#########################################################################
# Stop All TWS Instances
#########################################################################

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Stopping all TWS instances...${NC}"

# Find all TWS processes
TWS_PIDS=$(ps aux | grep "Trader Workstation" | grep -v grep | awk '{print $2}')

if [ -z "$TWS_PIDS" ]; then
    echo -e "${YELLOW}No TWS instances running${NC}"
    exit 0
fi

# Kill each process
for PID in $TWS_PIDS; do
    echo -e "${YELLOW}→ Stopping PID: $PID${NC}"
    kill $PID
done

sleep 2

# Force kill if still running
TWS_PIDS=$(ps aux | grep "Trader Workstation" | grep -v grep | awk '{print $2}')
if [ ! -z "$TWS_PIDS" ]; then
    echo -e "${RED}Force stopping remaining processes...${NC}"
    for PID in $TWS_PIDS; do
        kill -9 $PID
    done
fi

echo -e "${GREEN}✓ All TWS instances stopped${NC}"
