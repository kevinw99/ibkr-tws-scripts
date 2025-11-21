# Troubleshooting Guide

## ✅ FIXED: IBC Automation Now Working

**Status**: The IBC automation is now functioning correctly. IBC successfully:
- Launches TWS with visible GUI windows
- Detects the login dialog
- Automatically fills in credentials
- Clicks the login button

If you see "Unrecognized Username or Password", you need to update your credentials in the config files.

---

# Previous Issue: TWS Not Showing Windows (RESOLVED)

## Problem

When running the launch scripts, you see messages like:
```
✓ TWS started for weng0754 (PID: 77166, API Port 7497)
```

But **no TWS windows appear** on screen.

## Root Cause

IBC's `twsstartmacos.sh` script is designed to be run from an **interactive Terminal session**. When run from background/automated scripts (like from Claude Code), it doesn't properly launch the GUI application.

##  Solution Options

### Option 1: Launch from Terminal (Recommended for Daily Use)

Open Terminal.app and run:

```bash
# Launch both accounts
~/ibkr_tws/scripts/launch-all.sh

# Or launch individual accounts
~/ibkr_tws/scripts/launch-weng0754.sh
~/ibkr_tws/scripts/launch-weng9999.sh
```

The TWS windows will appear and IBC will automatically log you in.

### Option 2: Use Manual Launch with Your Existing Alias

Your existing `tws` alias works perfectly for launching TWS manually:

```bash
# From ~/.bash_profile
alias tws='open -n "/Users/kweng/Applications/Trader Workstation 10.37/Trader Workstation 10.37.app"'
```

Use this when you want to log in manually (no automation).

### Option 3: Create a Terminal-Friendly Launcher

I'll create a new script that opens Terminal and runs the IBC launcher there.

---

## Why This Happens

- **IBC requires TTY**: The IBC start script uses `osascript` and Terminal features
- **Background execution**: When run from background (like Claude Code), there's no TTY
- **macOS security**: GUI apps need proper session context to display windows

---

## Next Steps

Let me know which option you prefer:

1. ✅ **Use Terminal** - Simple, works now, just open Terminal first
2. ⚙️ **Modify scripts** - I can create scripts that launch Terminal automatically
3. 🔧 **Hybrid approach** - Manual launch + separate automation for login

The Terminal approach (Option 1) is the most reliable and is how IBC is designed to work.
