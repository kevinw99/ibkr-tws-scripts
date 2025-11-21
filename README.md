# IBKR TWS Automated Login - Multiple Accounts

This directory contains scripts and configurations to automate login for multiple Interactive Brokers TWS accounts.

## 📁 Directory Structure

```
~/ibkr_tws/
├── scripts/          # Launcher and management scripts
├── config/           # Configuration files (with credentials)
│   ├── weng0754/    # Account 1 config
│   └── weng9999/    # Account 2 config
├── logs/            # Log files for each account
└── docs/            # Additional documentation
```

## 🚀 Quick Start

### 1. Install IBC

```bash
cd ~/ibkr_tws/scripts
./setup-ibc.sh
```

This will:
- Download and install IBC (Interactive Brokers Controller)
- Create configuration files for both accounts
- Set up proper permissions

### 2. Launch TWS Instances

**Launch both accounts simultaneously:**
```bash
~/ibkr_tws/scripts/launch-all.sh
```

**Launch with auto-restart (kills existing instances):**
```bash
~/ibkr_tws/scripts/launch-all.sh --force
```

**Launch individual accounts:**
```bash
~/ibkr_tws/scripts/launch-weng0754.sh  # Account 1
~/ibkr_tws/scripts/launch-weng9999.sh  # Account 2
```

> **📘 Handling Existing Instances:** Scripts detect and prompt if TWS is already running. Use `--force` flag for automated restarts. See [docs/EXISTING_INSTANCES.md](docs/EXISTING_INSTANCES.md) for details.

### 3. Check Status

```bash
~/ibkr_tws/scripts/status.sh
```

### 4. Stop All Instances

```bash
~/ibkr_tws/scripts/stop-all.sh
```

## 📝 Account Information

| Account   | Username  | API Port | Config Location |
|-----------|-----------|----------|-----------------|
| Account 1 | weng0754  | 7497     | `~/ibkr_tws/config/weng0754/` |
| Account 2 | weng9999  | 7498     | `~/ibkr_tws/config/weng9999/` |

## 🔧 Available Scripts

| Script | Description |
|--------|-------------|
| `setup-ibc.sh` | Initial setup - downloads and configures IBC |
| `launch-all.sh` | Start both TWS accounts simultaneously |
| `launch-weng0754.sh` | Start only weng0754 account |
| `launch-weng9999.sh` | Start only weng9999 account |
| `stop-all.sh` | Stop all running TWS instances |
| `status.sh` | Show status of running instances and API ports |

## 📊 Log Files

Logs are automatically created in `~/ibkr_tws/logs/`:

```bash
# View live logs
tail -f ~/ibkr_tws/logs/weng0754.log
tail -f ~/ibkr_tws/logs/weng9999.log
```

## ⚙️ Configuration

Configuration files are located in:
- `~/ibkr_tws/config/weng0754/config.ini`
- `~/ibkr_tws/config/weng9999/config.ini`

### Key Settings

```ini
IbLoginId=weng0754              # Username
IbPassword=eeee5555             # Password (stored in plain text)
TradingMode=paper               # paper or live
ForceTwsApiPort=7497           # API port (must be unique per instance)
IbControllerPort=7462          # IBC control port (must be unique)
```

### Changing Passwords

Edit the config file directly:
```bash
nano ~/ibkr_tws/config/weng0754/config.ini
```

Or regenerate configs:
```bash
cd ~/ibkr_tws/scripts
./setup-ibc.sh
```

## 🔐 Security Considerations

**IMPORTANT:** Passwords are stored in plain text in the config files!

### Protect Your Credentials

1. **Set restrictive permissions** (already done by setup script):
   ```bash
   chmod 700 ~/ibkr_tws/config
   chmod 600 ~/ibkr_tws/config/*/config.ini
   ```

2. **Use encrypted disk** (optional but recommended):
   ```bash
   # Create encrypted disk image
   hdiutil create -size 50m -encryption AES-256 -volname "IBKR Config" ~/ibkr-secure.dmg

   # Mount and move config
   open ~/ibkr-secure.dmg
   mv ~/ibkr_tws/config/* /Volumes/IBKR\ Config/
   ln -s /Volumes/IBKR\ Config ~/ibkr_tws/config
   ```

3. **Enable FileVault** for full disk encryption (System Preferences → Security & Privacy → FileVault)

## 🔄 Adding Shell Aliases

Add to your `~/.bash_profile` or `~/.zshrc`:

```bash
# TWS Aliases
alias tws-all='~/ibkr_tws/scripts/launch-all.sh'
alias tws-0754='~/ibkr_tws/scripts/launch-weng0754.sh'
alias tws-9999='~/ibkr_tws/scripts/launch-weng9999.sh'
alias tws-stop='~/ibkr_tws/scripts/stop-all.sh'
alias tws-status='~/ibkr_tws/scripts/status.sh'
alias tws-logs-0754='tail -f ~/ibkr_tws/logs/weng0754.log'
alias tws-logs-9999='tail -f ~/ibkr_tws/logs/weng9999.log'
```

Then reload:
```bash
source ~/.bash_profile  # or source ~/.zshrc
```

Now you can use short commands:
```bash
tws-all        # Launch both accounts
tws-status     # Check status
tws-stop       # Stop all
```

## 🐛 Troubleshooting

### TWS Won't Start

1. **Check if IBC is installed:**
   ```bash
   ls -la /opt/ibc
   ```

2. **Verify TWS version in start script:**
   ```bash
   grep TWS_MAJOR_VRSN /opt/ibc/twsstartmacos.sh
   ls ~/Applications/ | grep "Trader Workstation"
   ```

3. **Check logs:**
   ```bash
   tail -50 ~/ibkr_tws/logs/weng0754.log
   ```

### Port Already in Use

If you get "port already in use" errors:

```bash
# Check what's using the ports
lsof -i :7497
lsof -i :7498

# Stop all TWS instances
~/ibkr_tws/scripts/stop-all.sh
```

### Login Fails

1. **Verify credentials** in config files:
   ```bash
   grep -E "IbLoginId|IbPassword" ~/ibkr_tws/config/weng0754/config.ini
   ```

2. **Check trading mode** (paper vs live):
   ```bash
   grep TradingMode ~/ibkr_tws/config/weng0754/config.ini
   ```

3. **Two-Factor Authentication:**
   - If 2FA is enabled, approve login on IBKR Mobile app
   - Keep phone nearby when starting TWS

### Multiple Instances Not Running

Each instance needs unique ports:
- Account 1: API Port 7497, IBC Port 7462
- Account 2: API Port 7498, IBC Port 7463

Verify in config files:
```bash
grep -E "ForceTwsApiPort|IbControllerPort" ~/ibkr_tws/config/*/config.ini
```

## 📚 Additional Resources

- **IBC GitHub:** https://github.com/IbcAlpha/IBC
- **IBC User Guide:** https://github.com/IbcAlpha/IBC/blob/master/userguide.md
- **TWS Downloads:** https://www.interactivebrokers.com/en/software/macDownload.php
- **API Documentation:** https://interactivebrokers.github.io/tws-api/

## 🔄 Updating

### Update IBC

```bash
# Edit setup-ibc.sh to change version
nano ~/ibkr_tws/scripts/setup-ibc.sh
# Change: IBC_VERSION="3.20.0" to new version

# Re-run setup
~/ibkr_tws/scripts/setup-ibc.sh
```

### Update TWS

After updating TWS:
```bash
# Update version in IBC start script
sudo nano /opt/ibc/twsstartmacos.sh
# Update: TWS_MAJOR_VRSN=10.37 to match new version
```

## ⚡ Auto-Start on Login (Optional)

To start TWS automatically when you log in:

```bash
# Create LaunchAgent
cat > ~/Library/LaunchAgents/com.ibkr.tws.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.ibkr.tws</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/kweng/ibkr_tws/scripts/launch-all.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/Users/kweng/ibkr_tws/logs/launchd.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/kweng/ibkr_tws/logs/launchd-error.log</string>
</dict>
</plist>
EOF

# Load the agent
launchctl load ~/Library/LaunchAgents/com.ibkr.tws.plist
```

To disable auto-start:
```bash
launchctl unload ~/Library/LaunchAgents/com.ibkr.tws.plist
```

## 📞 Support

For issues with:
- **IBC:** https://github.com/IbcAlpha/IBC/issues
- **TWS:** Contact IBKR support
- **These scripts:** Check logs in `~/ibkr_tws/logs/`

---

**Last Updated:** 2025-01-20
