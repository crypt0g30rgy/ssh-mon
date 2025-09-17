#!/bin/bash
# SSH Monitor Script - Sends alerts to Discord on successful SSH logins
# Logs failed SSH login attempts to a local file

LOGFILE="/var/log/auth.log"   # Debian/Ubuntu
# LOGFILE="/var/log/secure"   # RHEL/CentOS/Fedora

# Replace with your webhook URL
WEBHOOK_URL="https://discord.com/api/webhooks/XXXX/XXXXXXXX"

# File to store failed login attempts
FAILED_LOG="/var/log/ssh_failed.log"

# Ensure failed log file exists
touch "$FAILED_LOG"
chmod 600 "$FAILED_LOG"

tail -Fn0 "$LOGFILE" | \
while read line; do
    # ✅ Successful login
    if echo "$line" | grep -q "Accepted password\|Accepted publickey"; then
        TIMESTAMP=$(echo "$line" | awk '{print $1, $2, $3}')
        USER=$(echo "$line" | awk '{for(i=1;i<=NF;i++) if ($i=="for") print $(i+1)}')
        IP=$(echo "$line" | awk '{for(i=1;i<=NF;i++) if ($i=="from") print $(i+1)}')
        
        MESSAGE="✅ SSH Login Detected
        - User: $USER
        - IP: $IP
        - Time: $TIMESTAMP
        - Host: $(hostname)"
        echo $MESSAGE

     MESSAGE=$(echo "$MESSAGE" | sed ':a;N;$!ba;s/\n/\\n/g')
     echo "{\"content\": \"$MESSAGE\"}" | curl -H "Content-Type: application/json" \
     -X POST \
     -d @- \
     "$WEBHOOK_URL"
    fi

    # ❌ Failed login
    if echo "$line" | grep -q "Failed password"; then
        TIMESTAMP=$(echo "$line" | awk '{print $1, $2, $3}')
        USER=$(echo "$line" | awk '{for(i=1;i<=NF;i++) if ($i=="for") print $(i+1)}')
        IP=$(echo "$line" | awk '{for(i=1;i<=NF;i++) if ($i=="from") print $(i+1)}')
        
        echo "❌ Failed SSH login: User=$USER IP=$IP Time=$TIMESTAMP" >> "$FAILED_LOG"
    fi
done
