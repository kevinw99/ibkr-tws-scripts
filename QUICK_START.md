# TWS Auto-Login Quick Reference

## All Available Commands

### Launch Both Accounts (Recommended)
```bash
tws-auto-both              # Kills existing, launches both weng0754 + weng9999
```

### Launch Single Account
```bash
tws-auto                   # Launch weng0754 (default)
tws-auto-0754              # Launch weng0754 explicitly
tws-auto-9999              # Launch weng9999 explicitly
```

### Force Restart (Skip Prompts)
```bash
tws-auto-force             # Force restart weng0754
tws-auto-0754-force        # Force restart weng0754
tws-auto-9999-force        # Force restart weng9999
```
Note: `tws-auto-both` already auto-kills existing instances, no force needed

### Check Status
```bash
~/ibkr_tws/scripts/status.sh    # Show running instances and API ports
```

### Stop All Instances
```bash
pkill -f "JavaApplicationStub"  # Kill all TWS instances
```

## What Each Command Does

### `tws-auto-both` (MAIN COMMAND)
- **Kills** any existing TWS instances automatically
- **Launches** weng0754 first
  - Opens TWS
  - Waits for login window (up to 30 seconds)
  - Auto-fills username: weng0754
  - Auto-fills password
  - Auto-clicks Login button
- **Waits** 15 seconds for first account to complete
- **Launches** weng9999 second
  - Same auto-login process
- **Result**: Two TWS windows running simultaneously

### `tws-auto-0754` or `tws-auto-9999` (SINGLE ACCOUNT)
- **Launches** the specified account with auto-login
- **Allows** multiple instances to run simultaneously
- **No blocking** - you can run both accounts this way too
- **Result**: One additional TWS window running

### `tws-auto-0754-force` (FORCE MODE)
- **Kills** existing TWS instances without asking
- **Launches** the account with auto-login
- **Result**: Fresh instance, no prompts

## Timing Details

- **Initial wait after opening TWS**: 10 seconds
- **Wait for JavaApplicationStub process**: Up to 30 seconds
- **Delay between keystrokes**: 0.8 seconds
- **Delay between launching both accounts**: 15 seconds

## Troubleshooting

### Password appears in terminal
**Problem**: You see `nnnn9999` or `eeee5555` in your terminal
**Cause**: Login window wasn't ready when AppleScript tried to type
**Fix**: Script now waits longer (10s + up to 30s). If still happening, increase sleep time in script.

### Only one instance launches when using `tws-auto-both`
**Problem**: Second account doesn't appear
**Cause**: Not enough time between launches
**Fix**: Script now waits 15 seconds between launches. Already fixed.

### AppleScript permission error
**Problem**: "AppleScript couldn't auto-fill"
**Fix**:
1. System Preferences → Privacy & Security → Accessibility
2. Click lock and enter password
3. Add Terminal (or iTerm) to allowed apps
4. Try again

### Wrong account credentials
**Problem**: Login fails
**Fix**: Edit `/Users/kweng/ibkr_tws/scripts/tws-auto-v2.sh`
- Line 74: `PASSWORD="eeee5555"` (weng0754 password)
- Line 77: `PASSWORD="nnnn9999"` (weng9999 password)

## Account Details

| Alias | Username | Password (in script) | What it does |
|-------|----------|---------------------|--------------|
| `tws-auto-both` | weng0754 + weng9999 | eeee5555 + nnnn9999 | Launch both |
| `tws-auto-0754` | weng0754 | eeee5555 | Launch weng0754 |
| `tws-auto-9999` | weng9999 | nnnn9999 | Launch weng9999 |

## Example Workflow

```bash
# Morning routine - launch both accounts
tws-auto-both

# Wait ~30 seconds total
# First account (weng0754) logs in
# Approve 2FA on phone for weng0754

# Wait ~15 more seconds
# Second account (weng9999) logs in
# Approve 2FA on phone for weng9999

# Check status
~/ibkr_tws/scripts/status.sh

# End of day - stop all
pkill -f "JavaApplicationStub"
```

## Files Location

- **Main script**: `~/ibkr_tws/scripts/tws-auto-v2.sh`
- **Aliases defined in**: `~/.bash_profile` (lines 109-119)
- **This guide**: `~/ibkr_tws/QUICK_START.md`

---
**Last Updated**: 2024-11-21
