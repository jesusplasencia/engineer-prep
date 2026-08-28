#!/usr/bin/env bash
# ==============================================================================
# 02-log-rotator-monitor.sh
# Safely compresses inactive log files older than N days, truncates large active
# logs using copytruncate technique, and enforces maximum retention limits.
# ==============================================================================
set -euo pipefail

LOG_DIR="${1:-/var/log/custom-apps}"
MAX_SIZE_MB="${2:-500}"
RETENTION_DAYS="${3:-7}"

echo "======================================================================"
echo "📦 Log Rotator & Monitor"
echo "Target Dir:      $LOG_DIR"
echo "Max Active Size: ${MAX_SIZE_MB}MB"
echo "Retention Days:  ${RETENTION_DAYS} days"
echo "======================================================================"

if [[ ! -d "$LOG_DIR" ]]; then
    echo "⚠️ Target directory '$LOG_DIR' does not exist. Creating mock directory for testing..."
    mkdir -p "$LOG_DIR"
    # Create sample logs for demonstration
    echo "Sample active log line..." > "$LOG_DIR/app.log"
    echo "Old archived log line..." > "$LOG_DIR/app.log.1"
fi

# Step 1: Truncate active logs exceeding MAX_SIZE_MB using copytruncate
echo "1️⃣ Checking oversized active .log files..."
find "$LOG_DIR" -maxdepth 1 -type f -name "*.log" -size "+${MAX_SIZE_MB}M" | while read -r logfile; do
    timestamp=$(date +%Y%m%d_%H%M%S)
    archived="${logfile}.${timestamp}"
    echo "   🔄 Rotating $logfile -> $archived"
    cp -p "$logfile" "$archived"
    : > "$logfile"  # atomic truncate without closing handle
    gzip -9 "$archived"
    echo "   ✅ Compressed $archived.gz"
done

# Step 2: Compress uncompressed historical logs
echo "2️⃣ Compressing uncompressed historical logs (*.log.*)..."
find "$LOG_DIR" -maxdepth 1 -type f \( -name "*.log.*" ! -name "*.gz" \) | while read -r raw_archive; do
    echo "   🗜️ Compressing $raw_archive..."
    gzip -9 "$raw_archive"
done

# Step 3: Delete archives older than retention window
echo "3️⃣ Purging archives older than $RETENTION_DAYS days..."
find "$LOG_DIR" -maxdepth 1 -type f -name "*.gz" -mtime "+$RETENTION_DAYS" -print -delete || true

echo "✅ Log rotation cycle finished successfully."

