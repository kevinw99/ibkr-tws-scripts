# IBC Automation Fix Summary

## Problem
IBC was not automating the TWS login. The TWS GUI would appear, but IBC would not fill in credentials or click the login button, leaving the user at the manual login screen.

## Root Cause
The IBC start script (`/opt/ibc/twsstartmacos.sh`) had a hardcoded default configuration file path:
```bash
IBC_INI=~/ibc/config.ini
```

Our launch scripts were passing the config file path as an argument:
```bash
/opt/ibc/twsstartmacos.sh ~/ibkr_tws/config/weng0754/config.ini
```

However, the IBC start script **ignored this argument** and always used the hardcoded path. Since `~/ibc/config.ini` didn't exist, IBC would fail with:
```
Error: IBC configuration file: /Users/kweng/ibc/config.ini does not exist
```

## Solution

### 1. Created Custom Wrapper Script
Created `~/ibkr_tws/scripts/tws-launch-wrapper.sh` - a modified version of the IBC start script that respects the `IBC_INI` environment variable:

```bash
# Original (hardcoded):
IBC_INI=~/ibc/config.ini

# Fixed (respects environment variable):
IBC_INI=${IBC_INI:-~/ibc/config.ini}
```

This allows the config file path to be set via environment variable while maintaining a fallback default.

### 2. Updated Launch Scripts
Modified all three launch scripts to:
- Use the wrapper script instead of the original IBC script
- Set the `IBC_INI` environment variable before launching

**Before:**
```bash
IBC_DIR="/opt/ibc"
"$IBC_DIR/twsstartmacos.sh" "$CONFIG_DIR/$ACCOUNT/config.ini" > ...
```

**After:**
```bash
IBC_DIR="$HOME/ibkr_tws/scripts"
IBC_INI="$CONFIG_DIR/$ACCOUNT/config.ini" "$IBC_DIR/tws-launch-wrapper.sh" -inline > ...
```

### 3. Added `-inline` Flag
The `-inline` flag prevents the script from trying to open a new Terminal window, which was causing issues when run from background/automated contexts.

## Verification

After the fix, IBC log shows successful operation:
```
Starting IBC version 3.20.0
Arguments:
  --ibc-ini = /Users/kweng/ibkr_tws/config/weng0754/config.ini

Starting TWS
detected frame entitled: Login
Login dialog WINDOW_OPENED
[IBC attempts to fill credentials and log in]
```

## Files Modified

1. **Created:**
   - `/Users/kweng/ibkr_tws/scripts/tws-launch-wrapper.sh` - Custom IBC wrapper script

2. **Updated:**
   - `/Users/kweng/ibkr_tws/scripts/launch-weng0754.sh` - Use wrapper, set IBC_INI env var
   - `/Users/kweng/ibkr_tws/scripts/launch-weng9999.sh` - Use wrapper, set IBC_INI env var
   - `/Users/kweng/ibkr_tws/scripts/launch-all.sh` - Use wrapper, set IBC_INI env var

## Testing

To test the fix:
```bash
# Stop any running instances
~/ibkr_tws/scripts/stop-all.sh

# Launch single account
~/ibkr_tws/scripts/launch-weng0754.sh

# Check IBC log
tail -f ~/ibc/logs/ibc-3.20.0_TWS-10.37_Thursday.txt
```

You should see:
- TWS GUI window appears
- IBC detects the login dialog
- IBC attempts to fill in credentials
- If credentials are correct, login proceeds automatically

## Next Steps

Update the credentials in the config files:
```bash
nano ~/ibkr_tws/config/weng0754/config.ini
nano ~/ibkr_tws/config/weng9999/config.ini
```

Change `IbLoginId` and `IbPassword` to your actual IBKR credentials.

---

**Fixed on:** 2025-11-20
