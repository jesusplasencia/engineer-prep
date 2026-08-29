#!/usr/bin/env bash
set -euo pipefail

TARGET_PATH="${1:-/tmp/saint-john/bad.log}"

echo "======================================================================"
echo "🔍 Disk Cleanup - Target Directory: $TARGET_PATH"
echo "======================================================================"

if [[ ! -e "$TARGET_PATH" ]]; then
    echo "⚠️ Target path does not exist."
    exit 0
fi

# Step 1: Find all PIDs associated with the file
PIDS=$(lsof -t "$TARGET_PATH" 2>/dev/null || true)

if [[ -n "$PIDS" ]]; then
    echo "🎯 Killing rogue processes: $PIDS"
    echo "$PIDS" | xargs -r kill -9
    sleep 0.2
else
    echo "ℹ️ No active processes holding $TARGET_PATH"
fi

# 2. Remove the file
if [[ -f "$TARGET_PATH" ]]; then
    : > "$TARGET_PATH"   # Truncate first
    rm -f "$TARGET_PATH" # Delete file
    echo "✅ Storage reclaimed successfully."
fi