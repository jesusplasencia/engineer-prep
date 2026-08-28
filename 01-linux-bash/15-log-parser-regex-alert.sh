#!/usr/bin/env bash
# ==============================================================================
# 15-log-parser-regex-alert.sh
# Streams and parses web server / application logs in real-time, extracts HTTP
# status codes with awk/sed, and alerts when 5xx error rate exceeds threshold.
# ==============================================================================
set -euo pipefail

LOG_FILE="${1:-/tmp/sample_access.log}"
ERROR_THRESHOLD="${2:-5}"

echo "======================================================================"
echo "⚡ Real-time Log Stream Parser & 5xx Alert Watcher"
echo "Target Log:  $LOG_FILE"
echo "Threshold:   $ERROR_THRESHOLD errors / window"
echo "======================================================================"

# Create mock log if it doesn't exist for demonstration
if [[ ! -f "$LOG_FILE" ]]; then
    echo "Creating sample log $LOG_FILE..."
    cat <<EOF > "$LOG_FILE"
192.168.1.10 - - [27/Aug/2026:12:00:01] "GET /api/v1/health HTTP/1.1" 200 120
192.168.1.11 - - [27/Aug/2026:12:00:02] "POST /api/v1/checkout HTTP/1.1" 500 450
192.168.1.12 - - [27/Aug/2026:12:00:03] "POST /api/v1/checkout HTTP/1.1" 502 210
192.168.1.13 - - [27/Aug/2026:12:00:04] "GET /api/v1/products HTTP/1.1" 200 1500
192.168.1.14 - - [27/Aug/2026:12:00:05] "POST /api/v1/orders HTTP/1.1" 503 89
192.168.1.15 - - [27/Aug/2026:12:00:06] "POST /api/v1/orders HTTP/1.1" 500 312
192.168.1.16 - - [27/Aug/2026:12:00:07] "GET /api/v1/users HTTP/1.1" 500 240
EOF
fi

# Parse HTTP Status Codes breakdown
echo "📊 HTTP Status Code Breakdown in $LOG_FILE:"
awk '{print $(NF-1)}' "$LOG_FILE" | grep -E '^[0-9]{3}$' | sort | uniq -c | sort -nr || true

echo ""
# Count 5xx errors
COUNT_5XX=$(awk '$9 ~ /^5[0-9]{2}$/ {print $0}' "$LOG_FILE" | wc -l)
echo "🚨 Total 5xx Server Errors: $COUNT_5XX"

if [[ "$COUNT_5XX" -ge "$ERROR_THRESHOLD" ]]; then
    echo "🔥 ALERT TRIGGERED: 5xx errors ($COUNT_5XX) reached or exceeded threshold ($ERROR_THRESHOLD)!"
    echo "Top failing endpoints:"
    awk '$9 ~ /^5[0-9]{2}$/ {print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr
else
    echo "✅ 5xx error rate is within acceptable baseline."
fi

