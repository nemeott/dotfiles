#!/usr/bin/env bash
set -e

echo "=== WPA2-Enterprise WiFi setup ==="

# Ask for SSID
read -rp "WiFi name (SSID): " SSID

# Ask for identity
read -rp "Identity (username): " IDENTITY

# Ask for password (silent)
read -rsp "Password: " PASSWORD
echo

# Detect WiFi interface
IFACE=$(nmcli -t -f DEVICE,TYPE device status | awk -F: '$2=="wifi"{print $1}')

if [[ -z "$IFACE" ]]; then
  echo "❌ No WiFi interface found"
  exit 1
fi

echo "Using interface: $IFACE"

# Add connection
nmcli connection add type wifi \
  ifname "$IFACE" \
  con-name "$SSID" \
  ssid "$SSID" \
  wifi-sec.key-mgmt wpa-eap \
  802-1x.eap peap \
  802-1x.phase2-auth mschapv2 \
  802-1x.identity "$IDENTITY" \
  802-1x.password "$PASSWORD"

# Bring connection up
nmcli connection up "$SSID"

echo "✅ Connected to $SSID"
