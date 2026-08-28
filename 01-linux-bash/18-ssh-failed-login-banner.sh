#!/usr/bin/env bash
# ==============================================================================
# 18-ssh-failed-login-banner.sh
# Scans SSH authentication logs (/var/log/auth.log or /var/log/secure) to detect
# brute-force login attempts and outputs actionable firewall block rules.
# ==============================================================================
set -euo pipefail

THRESHOLD="${1:-5}"
AUTH_LOG=""

for path in /var/log/auth.log /var/log/secure; do
    if [[ -f "$path" ]]; then
        AUTH_LOG="$path"
        break
    fi
done

echo "======================================================================"
echo "🛡️ SSH Brute-Force Detector & Firewall Rule Generator"
echo "Threshold: $THRESHOLD failed attempts"
echo "======================================================================"

if [[ -z "$AUTH_LOG" ]]; then
    echo "ℹ️ No auth.log/secure found. Simulating inspection with mock data..."
    MOCK_IPS="198.51.100.23 (12 attempts)
203.0.113.88 (8 attempts)"
    echo "🚨 Suspicious Remote IPs:"
    echo "$MOCK_IPS"
    echo ""
    echo "💡 Suggested iptables commands to drop offending IPs:"
    echo "   iptables -A INPUT -s 198.51.100.23 -j DROP"
    echo "   iptables -A INPUT -s 203.0.113.88 -j DROP"
    exit 0
fi

echo "Scanning $AUTH_LOG..."
FAILED_IPS=$(grep -i "Failed password" "$AUTH_LOG" | awk '{
    for (i=1; i<=NF; i++) {
        if ($i == "from") { print $(i+1) }
    }
}' | sort | uniq -c | sort -nr | awk -v thresh="$THRESHOLD" '$1 >= thresh {print $2, "(" $1 " attempts)"}')

if [[ -z "$FAILED_IPS" ]]; then
    echo "✅ No IPs exceeding $THRESHOLD failed SSH login attempts."
else
    echo "🚨 Offending IPs found:"
    echo "$FAILED_IPS"
    echo ""
    echo "💡 Generated iptables DROP commands:"
    echo "$FAILED_IPS" | awk '{print "iptables -A INPUT -s " $1 " -j DROP"}'
fi

