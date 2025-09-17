# SSH Monitor with Discord Alerts

This script monitors your server for **successful SSH logins** and sends an alert to a **Discord channel** via webhook.

## 🚀 Setup

### 1. Clone repo

```bash
git clone https://github.com/YOURUSERNAME/ssh-monitor-discord.git
cd ssh-monitor-discord
```

### 2. Configure webhook

Edit `ssh_monitor.sh` and replace:

```bash
WEBHOOK_URL="https://discord.com/api/webhooks/XXXX/XXXXXXXX"
```

### 3. Install script

```bash
sudo cp ssh_monitor.sh /usr/local/bin/ssh_monitor.sh
sudo chmod +x /usr/local/bin/ssh_monitor.sh
```

### 4. Install systemd service

```bash
sudo cp ssh-monitor.service /etc/systemd/system/ssh-monitor.service
sudo systemctl daemon-reload
sudo systemctl enable ssh-monitor.service
sudo systemctl start ssh-monitor.service
```

### 5. Check status

```bash
sudo systemctl status ssh-monitor.service
```

### 6. View logs

```bash
journalctl -u ssh-monitor.service -f
```

## ✅ Features

- Monitors SSH successful logins in real-time
- Sends alerts to Discord (username, IP, timestamp, hostname)
- Runs persistently as a systemd service
- Auto restarts if it crashes

## 🛡️ Security Notes

- Run as **root** (needed to read `/var/log/auth.log` or `/var/log/secure`)
- Store webhook URLs securely
- Works on **Debian/Ubuntu** (`/var/log/auth.log`) and **RHEL/CentOS/Fedora** (`/var/log/secure`)

## 📜 License

MIT
