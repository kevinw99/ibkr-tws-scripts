# Getting Started - TWS Automated Login

## Prerequisites

1. **TWS Standalone installed**
   - Download from: https://www.interactivebrokers.com/en/software/macDownload.php
   - ⚠️ Must be "standalone" version, NOT self-updating
   - Install location: `~/Applications/`

2. **Two IBKR accounts:**
   - weng0754 (password: eeee5555)
   - weng9999 (password: nnnn9999)

## Installation (One-Time Setup)

```bash
# 1. Run the setup script
cd ~/ibkr_tws/scripts
./setup-ibc.sh

# 2. Add convenience aliases (optional)
cat >> ~/.bash_profile << 'EOF'

# TWS Aliases
alias tws-all='~/ibkr_tws/scripts/launch-all.sh'
alias tws-0754='~/ibkr_tws/scripts/launch-weng0754.sh'
alias tws-9999='~/ibkr_tws/scripts/launch-weng9999.sh'
alias tws-stop='~/ibkr_tws/scripts/stop-all.sh'
alias tws-status='~/ibkr_tws/scripts/status.sh'
EOF

# 3. Reload shell
source ~/.bash_profile
```

## Daily Usage

### Start Both Accounts
```bash
tws-all
```
or
```bash
~/ibkr_tws/scripts/launch-all.sh
```

### Start Individual Accounts
```bash
tws-0754  # weng0754 only
tws-9999  # weng9999 only
```

### Check Status
```bash
tws-status
```

### Stop All Instances
```bash
tws-stop
```

### View Logs
```bash
tail -f ~/ibkr_tws/logs/weng0754.log
tail -f ~/ibkr_tws/logs/weng9999.log
```

## What Happens When You Run `tws-all`?

1. IBC starts TWS for weng0754
2. Automatically fills in username: `weng0754`
3. Automatically fills in password: `eeee5555`
4. Clicks "Log In" button
5. Waits 2 seconds
6. IBC starts TWS for weng9999
7. Automatically fills in username: `weng9999`
8. Automatically fills in password: `nnnn9999`
9. Clicks "Log In" button

Both instances run independently with separate API ports:
- weng0754: API Port 7497
- weng9999: API Port 7498

## Common Scenarios

### Scenario 1: Start Both Every Morning
```bash
# Just run this command
tws-all
```

### Scenario 2: Only Need One Account Today
```bash
# Start just weng0754
tws-0754

# Or just weng9999
tws-9999
```

### Scenario 3: Check If TWS is Running
```bash
tws-status
```

### Scenario 4: Close Everything at End of Day
```bash
tws-stop
```

### Scenario 5: Something Went Wrong, Restart Everything
```bash
tws-stop
sleep 3
tws-all
```

## Troubleshooting

### "IBC not installed"
```bash
cd ~/ibkr_tws/scripts
./setup-ibc.sh
```

### "Login failed"
Check credentials in config files:
```bash
cat ~/ibkr_tws/config/weng0754/config.ini | grep -E "IbLoginId|IbPassword"
cat ~/ibkr_tws/config/weng9999/config.ini | grep -E "IbLoginId|IbPassword"
```

### TWS Window Appears But Doesn't Login
- Check logs: `tail -f ~/ibkr_tws/logs/weng0754.log`
- Verify TWS version matches IBC: `grep TWS_MAJOR_VRSN /opt/ibc/twsstartmacos.sh`

### 2FA Required
- Keep phone nearby
- Approve login on IBKR Mobile app
- Login will complete automatically after approval

## Next Steps

- Read full documentation: `cat ~/ibkr_tws/README.md`
- Customize config: `nano ~/ibkr_tws/config/weng0754/config.ini`
- Set up auto-start on login (see README.md)

---

**Questions?** Check the main README.md or logs in ~/ibkr_tws/logs/
