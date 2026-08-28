#!/usr/bin/env bash
# ==============================================================================
# 12-disk-io-bottleneck-tracer.sh
# Analyzes I/O wait times (%wa), disk throughput, queue lengths, and identifies
# processes performing heavy synchronous read/write operations with iotop/pidstat.
# ==============================================================================
set -euo pipefail

DURATION="${1:-2}"
COUNT="${2:-3}"

echo "======================================================================"
echo "💽 Disk I/O Bottleneck & Latency Tracer"
echo "Sampling: $COUNT times every $DURATION seconds"
echo "======================================================================"

# Step 1: CPU I/O Wait (%wa) from vmstat
if command -v vmstat &>/dev/null; then
    echo "1️⃣ Virtual Memory & CPU I/O Wait (vmstat):"
    echo "   Look at columns 'b' (blocked on I/O) and 'wa' (CPU wait for I/O):"
    vmstat "$DURATION" "$COUNT"
fi

# Step 2: Disk device utilization (iostat)
if command -v iostat &>/dev/null; then
    echo ""
    echo "2️⃣ Device Utilization & Await Time (iostat -xz):"
    echo "   Look at '%util' (>80% indicates saturation) and 'await' (latency in ms):"
    iostat -xz "$DURATION" "$COUNT" || true
fi

# Step 3: Top processes performing disk I/O
if command -v pidstat &>/dev/null; then
    echo ""
    echo "3️⃣ Top Disk I/O Processes (pidstat -d):"
    pidstat -d "$DURATION" 1 | sort -k4 -nr | head -n 10 || true
elif command -v iotop &>/dev/null; then
    echo ""
    echo "3️⃣ Top Disk I/O Processes (iotop snapshot):"
    iotop -b -n 1 | head -n 15 || true
else
    echo ""
    echo "ℹ️ Tip: Install 'sysstat' (iostat, pidstat) or 'iotop' for granular per-process disk tracking."
fi

