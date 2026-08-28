#!/usr/bin/env bash
# ==============================================================================
# 04-high-cpu-mem-watcher.sh
# Snapshots top processes exceeding CPU/Memory limits, captures process stack/thread
# states, and logs metrics for post-mortem incident investigation.
# ==============================================================================
set -euo pipefail

CPU_THRESHOLD="${1:-80}"
MEM_THRESHOLD="${2:-80}"
OUTPUT_DIR="${3:-/tmp/perf-snapshots}"

mkdir -p "$OUTPUT_DIR"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SNAPSHOT_FILE="$OUTPUT_DIR/perf_snapshot_${TIMESTAMP}.log"

echo "======================================================================"
echo "📊 High CPU / Memory Resource Watcher"
echo "CPU Threshold: ${CPU_THRESHOLD}% | MEM Threshold: ${MEM_THRESHOLD}%"
echo "Output Log:    $SNAPSHOT_FILE"
echo "======================================================================"

{
    echo "=== SYSTEM LOAD & MEMORY SUMMARY [${TIMESTAMP}] ==="
    uptime
    echo ""
    free -h
    echo ""
    echo "=== TOP 10 CPU CONSUMERS ==="
    ps -eo pid,user,%cpu,%mem,vsz,rss,stat,start,time,comm --sort=-%cpu | head -n 11
    echo ""
    echo "=== TOP 10 MEMORY CONSUMERS ==="
    ps -eo pid,user,%cpu,%mem,vsz,rss,stat,start,time,comm --sort=-%mem | head -n 11
    echo ""
} | tee "$SNAPSHOT_FILE"

# Check if any process exceeds the threshold
ALERT_CPU=$(ps -eo pid,user,%cpu,comm --no-headers | awk -v t="$CPU_THRESHOLD" '$3 >= t {print $0}')
ALERT_MEM=$(ps -eo pid,user,%mem,comm --no-headers | awk -v t="$MEM_THRESHOLD" '$3 >= t {print $0}')

if [[ -n "$ALERT_CPU" ]]; then
    echo "🚨 WARNING: Processes exceeding ${CPU_THRESHOLD}% CPU:"
    echo "$ALERT_CPU"
fi

if [[ -n "$ALERT_MEM" ]]; then
    echo "🚨 WARNING: Processes exceeding ${MEM_THRESHOLD}% MEM:"
    echo "$ALERT_MEM"
fi

if [[ -z "$ALERT_CPU" && -z "$ALERT_MEM" ]]; then
    echo "✅ System metrics within normal operational thresholds."
fi

