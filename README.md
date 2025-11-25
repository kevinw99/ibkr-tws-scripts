# IBKR TWS Auto-Login Scripts

Automated login scripts for Interactive Brokers Trader Workstation (TWS) with AppleScript credential auto-fill.

## Quick Start

### Launch TWS

```bash
# Launch both accounts (recommended)
tws-auto-both

# Launch single account
tws-auto-0754    # weng0754 only
tws-auto-9999    # weng9999 only
tws-auto         # weng0754 (default)
```

### Force Restart

```bash
# Kill existing instances without prompting
tws-auto-both-force
tws-auto-0754-force
tws-auto-9999-force
```

### Management

```bash
# Check running instances and API ports
~/ibkr_tws/scripts/status.sh

# Kill all TWS instances
tws-kill
```

## How It Works

### `tws-auto-both` (Main Command)

1. Kills any existing TWS instances automatically
2. Launches **weng0754** first
   - Opens TWS app
   - Waits 10 seconds for login window
   - Auto-fills username and password via AppleScript
   - Auto-clicks Login button
3. Waits 15 seconds for first account to complete 2FA
4. Launches **weng9999** second (same auto-login process)
5. Result: Two TWS windows running simultaneously

### Single Account Launch

- `tws-auto-0754` or `tws-auto-9999` launch one account
- Multiple instances can run simultaneously
- No blocking between accounts

### Force Mode

- Kills existing instances without asking
- Useful for scripts and automation

## Account Details

| Alias | Username | Password Location | Port |
|-------|----------|-------------------|------|
| `tws-auto-0754` | weng0754 | Script line 59 | 7497 |
| `tws-auto-9999` | weng9999 | Script line 62 | 7498 |

Passwords are hardcoded in `/Users/kweng/ibkr_tws/scripts/tws-auto-v2.sh`:
- Line 59: `PASSWORD="eeee5555"` (weng0754)
- Line 62: `PASSWORD="nnnn9999"` (weng9999)

## Directory Structure

```
~/ibkr_tws/
├── scripts/
│   ├── tws-auto-v2.sh    # Main auto-login script
│   └── status.sh         # Check running instances
├── config/               # Config files (credentials)
├── logs/                 # Log files
└── README.md            # This file
```

## Timing Details

- Initial wait after launching TWS: **10 seconds**
- Delay between keystrokes: **0.5 seconds**
- Wait between launching both accounts: **15 seconds**

## Example Workflow

```bash
# Morning routine
tws-auto-both

# First account (weng0754) logs in (~10 seconds)
# Approve 2FA on phone for weng0754

# Second account (weng9999) logs in (~15 seconds later)
# Approve 2FA on phone for weng9999

# Check status
~/ibkr_tws/scripts/status.sh

# End of day
tws-kill
```

## Troubleshooting

### Password appears in terminal
**Problem**: You see `nnnn9999` or `eeee5555` typed in terminal

**Cause**: Login window wasn't ready when AppleScript tried to type

**Fix**: Already implemented - script waits 10 seconds. If still happening, increase sleep time in script.

### Only one instance launches with tws-auto-both
**Problem**: Second account doesn't appear

**Cause**: Not enough time between launches

**Fix**: Already implemented - 15 second wait. Should work now.

### AppleScript permission error
**Problem**: "AppleScript couldn't auto-fill credentials"

**Fix**:
1. System Settings → Privacy & Security → Accessibility
2. Add Terminal (or iTerm) to allowed apps
3. Try again

### Wrong credentials
**Problem**: Login fails

**Fix**: Edit passwords in script
```bash
nano ~/ibkr_tws/scripts/tws-auto-v2.sh
```
- Line 59: weng0754 password
- Line 62: weng9999 password

## Debugging Commands

```bash
# Check running TWS processes
ps aux | grep -i "JavaApplicationStub" | grep -v grep

# Check which ports TWS is using
lsof -i :7497
lsof -i :7498

# View logs (if configured)
tail -f ~/ibkr_tws/logs/weng0754.log
tail -f ~/ibkr_tws/logs/weng9999.log
```

## Security Considerations

**WARNING**: Passwords are hardcoded in plain text in the script!

### Protect Your Credentials

1. **Set restrictive permissions**:
   ```bash
   chmod 700 ~/ibkr_tws/scripts
   chmod 600 ~/ibkr_tws/scripts/tws-auto-v2.sh
   ```

2. **Use FileVault** for full disk encryption:
   - System Settings → Privacy & Security → FileVault

3. **Keep backups secure** - don't commit to public repos

## Shell Aliases

All aliases are defined in `~/.bash_profile` (lines 109-122):

```bash
# Launch aliases
alias tws-auto='~/ibkr_tws/scripts/tws-auto-v2.sh'
alias tws-auto-both='~/ibkr_tws/scripts/tws-auto-v2.sh both'
alias tws-auto-0754='~/ibkr_tws/scripts/tws-auto-v2.sh weng0754'
alias tws-auto-9999='~/ibkr_tws/scripts/tws-auto-v2.sh weng9999'

# Force restart aliases
alias tws-auto-force='~/ibkr_tws/scripts/tws-auto-v2.sh --force'
alias tws-auto-both-force='~/ibkr_tws/scripts/tws-auto-v2.sh both --force'
alias tws-auto-0754-force='~/ibkr_tws/scripts/tws-auto-v2.sh weng0754 --force'
alias tws-auto-9999-force='~/ibkr_tws/scripts/tws-auto-v2.sh weng9999 --force'

# Management
alias tws-kill='pkill -f "JavaApplicationStub" && echo "All TWS instances killed"'
```

Reload after changes:
```bash
source ~/.bash_profile
```

## Requirements

- macOS
- Trader Workstation 10.37 (or adjust app path in script)
- Terminal or iTerm with Accessibility permissions

## Files

- **Main script**: `~/ibkr_tws/scripts/tws-auto-v2.sh`
- **Status checker**: `~/ibkr_tws/scripts/status.sh`
- **Aliases**: `~/.bash_profile`
- **Command reference**: `~/ibkr_tws/COMMANDS.txt`
- **Quick start guide**: `~/ibkr_tws/QUICK_START.md`

## Additional Documentation

- `COMMANDS.txt` - All available commands with examples
- `QUICK_START.md` - Detailed usage guide with troubleshooting
- `QUICK_REFERENCE.txt` - Command reference
- `GETTING_STARTED.md` - Setup instructions

## Resources

- **TWS Downloads**: https://www.interactivebrokers.com/en/software/macDownload.php
- **API Documentation**: https://interactivebrokers.github.io/tws-api/

---

**Last Updated**: 2025-11-21
