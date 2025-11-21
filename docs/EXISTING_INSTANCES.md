# Handling Existing TWS Instances

## Overview

The launcher scripts now intelligently handle existing TWS instances to prevent conflicts and give you control over what happens.

---

## Behavior Summary

### When No Instances Are Running
✅ Scripts launch TWS normally with automated login

### When Instances Are Already Running
⚠️ Scripts detect existing instances and give you options

---

## Launch-All Script Behavior

When you run `launch-all.sh` and TWS is already running:

### Interactive Mode (Default)
```bash
~/ibkr_tws/scripts/launch-all.sh
```

**You will see:**
```
⚠️  Warning: 2 TWS instance(s) already running

Existing instances:
  PID: 12345 - Started: 9:30AM
  PID: 12346 - Started: 9:30AM

What would you like to do?
  1) Stop existing and launch new instances (recommended)
  2) Launch new instances alongside existing ones
  3) Cancel
```

**Options:**
1. **Stop and restart** - Kills existing, launches fresh instances (safest)
2. **Launch alongside** - Tries to run multiple instances (may cause port conflicts!)
3. **Cancel** - Does nothing, exits safely

### Force Mode (Auto-Kill)
```bash
~/ibkr_tws/scripts/launch-all.sh --force
# or
~/ibkr_tws/scripts/launch-all.sh -f
```

**Behavior:**
- Automatically stops all existing TWS instances
- Waits 3 seconds
- Launches both new instances
- **No prompts, no questions**

**Use case:** Scripting, automation, cron jobs

### Skip Mode (Don't Check)
```bash
~/ibkr_tws/scripts/launch-all.sh --skip
# or
~/ibkr_tws/scripts/launch-all.sh -s
```

**Behavior:**
- Ignores existing instances
- Attempts to launch anyway
- ⚠️ Will fail if ports are in use

**Use case:** Testing, debugging

---

## Individual Launcher Behavior

When you run individual account launchers:

### Interactive Mode (Default)
```bash
~/ibkr_tws/scripts/launch-weng0754.sh
```

**If port 7497 is in use:**
```
✗ API Port 7497 is already in use!
Process using port:
  java    12345  kweng  [details...]

Stop existing instance and restart? (y/N):
```

**Options:**
- `y` or `Y` - Kill existing instance and restart
- `n` or `N` - Cancel (default)

### Force Mode (Auto-Kill)
```bash
~/ibkr_tws/scripts/launch-weng0754.sh --force
```

**Behavior:**
- Automatically kills process on port 7497
- Waits 2 seconds
- Launches new instance
- No prompts

---

## Port Conflict Prevention

All scripts check if API ports are available **before** launching:

```bash
# Checks performed:
✓ Port 7497 (weng0754)
✓ Port 7498 (weng9999)
```

**If port is in use:**
```
✗ API Port 7497 is already in use!
Process using port:
COMMAND   PID   USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
java    12345  kweng   123u  IPv6  0xabc  0t0  TCP *:7497

Run 'tws-stop' or '~/ibkr_tws/scripts/stop-all.sh' to stop existing instances
```

**Script exits** - No launch attempt to prevent conflicts

---

## IBC Configuration

The config files have `ExistingSessionDetectedAction=primary`:

```ini
# ~/ibkr_tws/config/weng0754/config.ini
ExistingSessionDetectedAction=primary
```

**This means:**
- If IBKR detects another session from same account
- The **new** login becomes primary
- The **old** session is disconnected

**Alternative values:**
- `primary` - New session takes over (default)
- `secondary` - New session is secondary
- `manual` - User must choose

---

## Common Scenarios

### Scenario 1: Morning Restart
```bash
# Running TWS from yesterday, want fresh start
~/ibkr_tws/scripts/launch-all.sh
# Choose option 1: Stop existing and launch new
```

### Scenario 2: Automated Restart Script
```bash
#!/bin/bash
# Daily restart at 9:00 AM
~/ibkr_tws/scripts/launch-all.sh --force
```

### Scenario 3: Something Crashed, Need to Restart
```bash
# Stop everything first
~/ibkr_tws/scripts/stop-all.sh

# Wait a moment
sleep 3

# Launch fresh
~/ibkr_tws/scripts/launch-all.sh
```

### Scenario 4: Only Restart One Account
```bash
# Restart just weng0754
~/ibkr_tws/scripts/launch-weng0754.sh
# Answer 'y' to restart

# weng9999 keeps running undisturbed
```

### Scenario 5: Check Before Launching
```bash
# Check what's running
~/ibkr_tws/scripts/status.sh

# If something's running, stop it
~/ibkr_tws/scripts/stop-all.sh

# Then launch
~/ibkr_tws/scripts/launch-all.sh
```

---

## Troubleshooting

### "Port already in use" but no TWS running

**Problem:** Something else is using the port

**Solution:**
```bash
# Find what's using the port
lsof -i :7497
lsof -i :7498

# Kill specific PID
kill 12345

# Or use stop-all (only kills TWS)
~/ibkr_tws/scripts/stop-all.sh
```

### Multiple instances running, can't tell which is which

**Solution:**
```bash
# Use status script
~/ibkr_tws/scripts/status.sh

# Shows:
# - All running TWS instances
# - Which ports are active
# - Log file timestamps
```

### Force mode not working

**Check:**
```bash
# Run with verbose output
bash -x ~/ibkr_tws/scripts/launch-all.sh --force
```

### Scripts hang waiting for input

**Problem:** Running in non-interactive environment (cron, automation)

**Solution:** Always use `--force` flag for automated scripts

---

## Best Practices

### Daily Use
```bash
# Morning
alias tws-start='~/ibkr_tws/scripts/launch-all.sh'

# Evening
alias tws-stop='~/ibkr_tws/scripts/stop-all.sh'
```

### Automated/Cron
```bash
# Always use --force to avoid hanging
0 9 * * 1-5 ~/ibkr_tws/scripts/launch-all.sh --force
```

### Development/Testing
```bash
# Check before launching
~/ibkr_tws/scripts/status.sh && ~/ibkr_tws/scripts/launch-all.sh
```

### Recovery
```bash
# Clean slate
~/ibkr_tws/scripts/stop-all.sh
sleep 5
~/ibkr_tws/scripts/launch-all.sh --force
```

---

## Summary Table

| Command | Existing Instances | Port Conflict | Behavior |
|---------|-------------------|---------------|----------|
| `launch-all.sh` | Prompts user | Fails with error | Interactive |
| `launch-all.sh --force` | Auto-kills | Kills process | Automated |
| `launch-all.sh --skip` | Ignores | Fails with error | Testing |
| `launch-weng0754.sh` | Prompts user | Fails with error | Interactive |
| `launch-weng0754.sh --force` | Auto-kills | Kills process | Automated |
| `stop-all.sh` | Kills all | N/A | Safe cleanup |

---

**Updated:** 2025-01-20
