#!/usr/bin/env bash
# ==============================================================================
# 01-disk-cleanup-fuser.sh
# Identifies deleted or rogue files still held open by active processes
# (unreleased file descriptors), displays the culprit PIDs, and safely frees space.
#
# Related Challenge: SadServers "Saint John" & Ghost Disk Space Leaks
# ==============================================================================
set -euo pipefail

TARGET_PATH="${1:-/var/log}"
THRESHOLD_MB="${2:-10}"

echo "======================================================================"
echo "🔍 Disk Cleanup & File Descriptor Inspector (lsof / fuser / /proc)"
echo "Target Directory: $TARGET_PATH"
echo "Threshold Size:   >${THRESHOLD_MB}MB"
echo "======================================================================"

# Check for required tools
for tool in lsof fuser; do
    if ! command -v "$tool" &>/dev/null; then
        echo "⚠️ Tool '$tool' not installed. Install via: apt install -y psmisc lsof"
    fi
done

# Step 1: Detect "Ghost" Deleted Files (Files removed with rm but held open by processes)
echo ""
echo "1️⃣ Searching for unlinked (deleted) files still held open by processes..."
echo "----------------------------------------------------------------------"

if command -v lsof &>/dev/null; then
    # lsof +L1 shows files with a link count < 1 (i.e. deleted from filesystem)
    DELETED_OPEN=$(lsof +L1 2>/dev/null | awk 'NR>1 {print $1, $2, $3, $7, $NF}' || true)
    
    if [[ -n "$DELETED_OPEN" ]]; then
        echo "⚠️ Found processes holding deleted files in memory:"
        printf "%-15s %-10s %-10s %-12s %s\n" "COMMAND" "PID" "USER" "SIZE(Bytes)" "FILE"
        echo "$DELETED_OPEN" | while read -r cmd pid user size file; do
            printf "%-15s %-10s %-10s %-12s %s\n" "$cmd" "$pid" "$user" "$size" "$file"
        done
    else
        echo "✅ No deleted open files detected holding disk space."
    fi
else
    # Fallback to inspecting /proc directly
    echo "ℹ️ lsof not found, scanning /proc filesystem directly..."
    find /proc/*/fd -ls 2>/dev/null | grep '(deleted)' || echo "✅ No deleted files in /proc/*/fd."
fi

# Step 2: Target-specific inspection for a specific file or directory
echo ""
echo "2️⃣ Inspecting processes writing to or holding files in: $TARGET_PATH"
echo "----------------------------------------------------------------------"

if [[ -e "$TARGET_PATH" ]]; then
    if command -v fuser &>/dev/null; then
        echo "📌 Running 'fuser -v $TARGET_PATH':"
        fuser -v "$TARGET_PATH" 2>&1 || echo "   (No active processes locking $TARGET_PATH)"
    fi

    if command -v lsof &>/dev/null; then
        echo ""
        echo "📌 Running 'lsof +D $TARGET_PATH' (Top writers/holders):"
        lsof +D "$TARGET_PATH" 2>/dev/null | head -n 15 || echo "   (No open file handles found)"
    fi
else
    echo "ℹ️ Target path '$TARGET_PATH' does not exist currently."
fi

# Step 3: Mitigation Guide & Safe Remediation
echo ""
echo "======================================================================"
echo "💡 SRE Production Troubleshooting Playbook:"
echo "======================================================================"
echo "Scenario A: A process is writing uncontrollably to /path/to/app.log"
echo "   1. Find PID:      fuser -v /path/to/app.log  OR  lsof /path/to/app.log"
echo "   2. Inspect PID:   ls -l /proc/<PID>/exe && cat /proc/<PID>/cmdline"
echo "   3. Truncate live: : > /path/to/app.log (DO NOT use 'rm' if process is running!)"
echo "   4. Stop writer:   kill -15 <PID> (Graceful SIGTERM) or kill -9 <PID> (SIGKILL)"
echo ""
echo "Scenario B: Disk is 100% full, you deleted the file, but 'df -h' still shows 100%"
echo "   1. Find ghost FD: lsof | grep '(deleted)'"
echo "   2. Free space without restart:  : > /proc/<PID>/fd/<FD_NUM>"
echo "======================================================================"
