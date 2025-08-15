#!/bin/bash

SSID="MMDU"
USERNAME="11242300"
PASSWORD="fda514"
PORTAL_URL="http://192.168.1.1:8090/login.xml"

# 1. Connect to Wi-Fi if not connected
CURRENT_SSID=$(nmcli -t -f ACTIVE,SSID dev wifi | grep "^yes" | cut -d: -f2)

if [ "$CURRENT_SSID" != "$SSID" ]; then
    echo "🔍 Connecting to Wi-Fi: $SSID..."
    nmcli dev wifi connect "$SSID" >/dev/null 2>&1
    sleep 5
else
    echo "✅ Already connected to $SSID"
fi

# 2. Verify connection
CURRENT_SSID=$(nmcli -t -f ACTIVE,SSID dev wifi | grep "^yes" | cut -d: -f2)
if [ "$CURRENT_SSID" != "$SSID" ]; then
    echo "❌ Failed to connect to $SSID"
    exit 1
fi

# 3. Send POST request to captive portal
RESPONSE=$(curl -s -X POST "$PORTAL_URL" \
     -H "Content-Type: application/x-www-form-urlencoded" \
     -d "mode=191&username=$USERNAME&password=$PASSWORD&a=$(date +%s%3N)&producttype=0")

# 4. Parse XML response
if echo "$RESPONSE" | grep -q "<status><![CDATA[OK]]></status>"; then
    echo "✅ Login successful for user $USERNAME"
elif echo "$RESPONSE" | grep -q "signed in as"; then
    echo "✅ Already logged in as $USERNAME"
else
    echo "❌ Login failed"
    echo "🔎 Portal response:"
    echo "$RESPONSE"
fi
