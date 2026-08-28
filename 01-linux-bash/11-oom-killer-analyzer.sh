#!/usr/bin/env bash
# ==============================================================================
# 11-oom-killer-analyzer.sh
# Scans kernel ring buffer (dmesg) and journalctl logs to identify Out-Of-Memory
# (OOM) killer terminations, victim process names, scores, and memory cgroups.
# ==============================================================================
set -euo pipefail

echo "======================================================================"
echo "💀 Linux Kernel OOM Killer Incident Analyzer"
echo "======================================================================"

OOM_FOUND=false

# Search in dmesg
if command -v dmesg &>/dev/null; then
    echo "1️⃣ Checking kernel ring buffer (dmesg)..."
    OOM_DMESG=$(dmesg -T 2>/dev/null | grep -iE 'killed process|out of memory|oom-killer|invoked oom-killer' || true)
    if [[ -n "$OOM_DMESG" ]]; then
        OOM_FOUND=true
        echo "🚨 OOM Killer events detected in dmesg:"
        echo "$OOM_DMESG" | tail -n 15
    fi
fi

# Search in journalctl
if command -v journalctl &>/dev/null; then
    echo ""
    echo "2️⃣ Checking systemd journalctl for kernel OOM logs..."
    OOM_JOURNAL=$(journalctl -k --grep="oom-killer|Out of memory" -n 10 --no-pager 2>/dev/null || true)
    if [[ -n "$OOM_JOURNAL" ]]; then
        OOM_FOUND=true
        echo "🚨 OOM Killer events found in journalctl:"
        echo "$OOM_JOURNAL"
    fi
fi

# Top memory cgroups and system memory status
echo ""
echo "3️⃣ Current Memory Footprint & Cgroup Limits:"
free -h

if [[ "$OOM_FOUND" == "false" ]]; then
    echo ""
    echo "✅ No historical OOM Killer invocations found in recent logs."
fi

