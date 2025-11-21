#!/bin/bash

#########################################################################
# Hybrid Launch: Uses manual TWS launch (works reliably)
# User manually logs in with credentials auto-saved in browser
#########################################################################

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ACCOUNT="weng0754"
API_PORT=7497

echo -e "${YELLOW}Launching TWS for account: $ACCOUNT (Manual Login)${NC}"

# Check if port is in use
PORT_IN_USE=$(lsof -i :$API_PORT 2>/dev/null)

if [ ! -z "$PORT_IN_USE" ]; then
    echo -e "${RED}✗ API Port $API_PORT is already in use!${NC}"
    echo "Process using port:"
    echo "$PORT_IN_USE"
    exit 1
fi

# Launch TWS via app bundle (like the tws alias)
open -n "/Users/kweng/Applications/Trader Workstation 10.37/Trader Workstation 10.37-1.app"

echo -e "${GREEN}✓ TWS launched for $ACCOUNT${NC}"
echo -e "${YELLOW}→ Please log in manually${NC}"
echo -e "${YELLOW}→ Username: weng0754${NC}"
echo -e "${YELLOW}→ Select: Live Trading${NC}"
echo ""

