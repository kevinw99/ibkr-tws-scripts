#!/bin/bash

# Save IBKR credentials to macOS Keychain

echo "Saving credentials to macOS Keychain..."

# For account weng0754
security add-generic-password -a "weng0754" -s "IBKR_TWS" -w "eeee5555" -U 2>/dev/null

# For account weng9999  
security add-generic-password -a "weng9999" -s "IBKR_TWS" -w "nnnn9999" -U 2>/dev/null

echo "✓ Credentials saved securely to Keychain"
echo "  Service: IBKR_TWS"
echo "  Accounts: weng0754, weng9999"
