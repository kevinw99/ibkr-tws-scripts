#!/bin/bash

#########################################################################
# IBC Setup Script for Multiple TWS Accounts
#
# This script installs IBC and sets up configurations for multiple
# IBKR accounts to run simultaneously
#########################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}TWS Multi-Account Setup (IBC)${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Configuration
IBC_VERSION="3.20.0"
IBC_INSTALL_DIR="/opt/ibc"
IBKR_TWS_DIR="$HOME/ibkr_tws"
TWS_DIR="$HOME/Applications"

print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_info() { echo -e "${YELLOW}→ $1${NC}"; }

# Check if TWS is installed
print_info "Checking for TWS installation..."
if [ ! -d "$TWS_DIR" ]; then
    print_error "TWS not found in $TWS_DIR"
    echo "Please install TWS Standalone from: https://www.interactivebrokers.com/en/software/macDownload.php"
    exit 1
fi

# Find TWS version
TWS_VERSION_FOLDER=$(ls -d "$TWS_DIR/Trader Workstation"* 2>/dev/null | head -1)
if [ -z "$TWS_VERSION_FOLDER" ]; then
    print_error "Could not find TWS installation"
    exit 1
fi

TWS_VERSION_FOLDER=$(basename "$TWS_VERSION_FOLDER")
TWS_MAJOR_VERSION=$(echo "$TWS_VERSION_FOLDER" | sed 's/Trader Workstation //')
print_success "Found TWS version: $TWS_MAJOR_VERSION"

# Download IBC
print_info "Downloading IBC version $IBC_VERSION..."
IBC_ZIP="IBCMacos-$IBC_VERSION.zip"
IBC_URL="https://github.com/IbcAlpha/IBC/releases/download/$IBC_VERSION/$IBC_ZIP"

cd /tmp
if [ -f "$IBC_ZIP" ]; then rm "$IBC_ZIP"; fi

if ! curl -L -o "$IBC_ZIP" "$IBC_URL"; then
    print_error "Failed to download IBC"
    echo "Check: https://github.com/IbcAlpha/IBC/releases"
    exit 1
fi
print_success "Downloaded IBC"

# Install IBC
print_info "Installing IBC to $IBC_INSTALL_DIR..."
if [ -d "$IBC_INSTALL_DIR" ]; then
    sudo rm -rf "$IBC_INSTALL_DIR"
fi

sudo mkdir -p "$IBC_INSTALL_DIR"
sudo unzip -q "$IBC_ZIP" -d "$IBC_INSTALL_DIR"
sudo chmod -R o+x "$IBC_INSTALL_DIR"/*.sh "$IBC_INSTALL_DIR"/*/*.sh
print_success "IBC installed"

# Update TWS version in start script
print_info "Updating start script with TWS version..."
sudo sed -i '' "s/^TWS_MAJOR_VRSN=.*/TWS_MAJOR_VRSN=$TWS_MAJOR_VERSION/" "$IBC_INSTALL_DIR/twsstartmacos.sh"
print_success "Start script updated"

# Create config files for both accounts
print_info "Creating configuration files for accounts..."

# Copy template and customize for account 1: weng0754
cp "$IBC_INSTALL_DIR/config.ini" "$IBKR_TWS_DIR/config/weng0754/config.ini"

# Update account 1 settings
sed -i '' "s/^IbLoginId=.*/IbLoginId=weng0754/" "$IBKR_TWS_DIR/config/weng0754/config.ini"
sed -i '' "s/^IbPassword=.*/IbPassword=eeee5555/" "$IBKR_TWS_DIR/config/weng0754/config.ini"
sed -i '' "s/^TradingMode=.*/TradingMode=paper/" "$IBKR_TWS_DIR/config/weng0754/config.ini"
sed -i '' "s/^IbAutoClosedown=.*/IbAutoClosedown=no/" "$IBKR_TWS_DIR/config/weng0754/config.ini"
sed -i '' "s/^OverrideTwsApiPort=.*/OverrideTwsApiPort=7497/" "$IBKR_TWS_DIR/config/weng0754/config.ini"
sed -i '' "s/^IbControllerPort=.*/IbControllerPort=7462/" "$IBKR_TWS_DIR/config/weng0754/config.ini"
sed -i '' "s/^ExistingSessionDetectedAction=.*/ExistingSessionDetectedAction=primary/" "$IBKR_TWS_DIR/config/weng0754/config.ini"
sed -i '' "s/^MinimizeMainWindow=.*/MinimizeMainWindow=no/" "$IBKR_TWS_DIR/config/weng0754/config.ini"

# Copy template and customize for account 2: weng9999
cp "$IBC_INSTALL_DIR/config.ini" "$IBKR_TWS_DIR/config/weng9999/config.ini"

# Update account 2 settings
sed -i '' "s/^IbLoginId=.*/IbLoginId=weng9999/" "$IBKR_TWS_DIR/config/weng9999/config.ini"
sed -i '' "s/^IbPassword=.*/IbPassword=nnnn9999/" "$IBKR_TWS_DIR/config/weng9999/config.ini"
sed -i '' "s/^TradingMode=.*/TradingMode=paper/" "$IBKR_TWS_DIR/config/weng9999/config.ini"
sed -i '' "s/^IbAutoClosedown=.*/IbAutoClosedown=no/" "$IBKR_TWS_DIR/config/weng9999/config.ini"
sed -i '' "s/^OverrideTwsApiPort=.*/OverrideTwsApiPort=7498/" "$IBKR_TWS_DIR/config/weng9999/config.ini"
sed -i '' "s/^IbControllerPort=.*/IbControllerPort=7463/" "$IBKR_TWS_DIR/config/weng9999/config.ini"
sed -i '' "s/^ExistingSessionDetectedAction=.*/ExistingSessionDetectedAction=primary/" "$IBKR_TWS_DIR/config/weng9999/config.ini"
sed -i '' "s/^MinimizeMainWindow=.*/MinimizeMainWindow=no/" "$IBKR_TWS_DIR/config/weng9999/config.ini"

chmod 600 "$IBKR_TWS_DIR/config/weng0754/config.ini"
chmod 600 "$IBKR_TWS_DIR/config/weng9999/config.ini"
print_success "Configuration files created"

# Cleanup
rm "/tmp/$IBC_ZIP"

# Success message
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}IBC Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}\n"

echo -e "${BLUE}Configuration:${NC}"
echo -e "  Account 1: ${YELLOW}weng0754${NC} (API Port: 7497)"
echo -e "  Account 2: ${YELLOW}weng9999${NC} (API Port: 7498)"
echo ""
echo -e "${BLUE}Next step:${NC}"
echo -e "  Use the launcher scripts in ${YELLOW}~/ibkr_tws/scripts/${NC}"
echo ""
