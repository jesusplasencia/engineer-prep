#!/usr/bin/env bash
# ==============================================================================
# 17-swap-pressure-monitor.sh
# Analyzes swap memory thrashing, reads vm.swappiness, and iterates over /proc
# to discover the exact PIDs and process names consuming physical swap space.
# ==============================================================================
set -euo pipefail

echo "======================================================================"
echo "🔄 Swap Memory Pressure & Per-Process Swap Auditor"
echo "======================================================================"

# Step 1: Overall swap usage
echo "1️⃣ Global Swap Utilization:"
free -h | grep -E 'total|Swap'

if [[ -f /proc/sys/vm/swappiness ]]; then
    echo "ℹ️ Current vm.swappiness: $(cat /proc/sys/vm/swappiness)"
fi

echo ""
echo "2️⃣ Top 10 Swap-Consuming Processes (extracted from /proc/<PID>/smaps):"
printf "%-10s %-12s %s\n" "PID" "SWAP USED" "COMMAND"
echo "----------------------------------------------------------------------"

# Find swap usage per process
for pid_dir in /proc/[0-9]*; do
    pid="${pid_dir##*/}"
    if [[ -r "$pid_dir/smaps_rollup" ]]; then
        swap_kb=$(awk '/^Swap:/ {print $2}' "$pid_dir/smaps_rollup" 2>/dev/null || echo 0)
    elif [[ -r "$pid_dir/smaps" ]]; then
        swap_kb=$(awk '/^Swap:/ {sum+=$2} END {print sum}' "$pid_dir/smaps" 2>/dev/null || echo 0)
    else
        swap_kb=0
    fi
    
    if [[ "$swap_kb" -gt 1024 ]]; then # more than 1MB
        comm=$(cat "$pid_dir/comm" 2>/dev/null || echo "unknown")
        printf "%-10s %-12s %s\n" "$pid" "$((swap_kb / 1024)) MB" "$comm"
    fi
done | sort -k2 -nr | head -n 10 || echo "No high swap consumers."

echo "======================================================================"

