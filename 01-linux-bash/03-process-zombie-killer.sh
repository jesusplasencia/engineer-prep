#!/usr/bin/env bash
# ==============================================================================
# 03-process-zombie-killer.sh
# Identifies zombie / defunct processes (state Z), discovers the parent process
# (PPID) failing to reap child exit codes, and provides actionable remedies.
# ==============================================================================
set -euo pipefail

echo "======================================================================"
echo "🧟 Zombie (<defunct>) Process Detector & Parent Inspector"
echo "======================================================================"

# Find processes in state Z
ZOMBIES=$(ps -eo stat,pid,ppid,comm,args | awk '$1 ~ /^Z/ {print $0}')

if [[ -z "$ZOMBIES" ]]; then
    echo "✅ No zombie processes currently found on the system."
    exit 0
fi

echo "⚠️ Zombie processes detected:"
printf "%-8s %-8s %-8s %-15s %s\n" "STAT" "PID" "PPID" "COMMAND" "ARGS"
echo "----------------------------------------------------------------------"
echo "$ZOMBIES"
echo "----------------------------------------------------------------------"

# Extract unique Parent PIDs
PARENT_PIDS=$(echo "$ZOMBIES" | awk '{print $3}' | sort -u)

echo "🔍 Analyzing Parent Processes responsible for un-reaped children:"
for ppid in $PARENT_PIDS; do
    if [[ "$ppid" -eq 1 ]]; then
        echo "ℹ️ PPID 1 (init/systemd) will automatically reap these zombies shortly."
    else
        parent_info=$(ps -p "$ppid" -o pid,user,stat,comm,args --no-headers 2>/dev/null || true)
        if [[ -n "$parent_info" ]]; then
            echo "   Parent PID: $ppid -> $parent_info"
            echo "   💡 To notify parent to reap children, send SIGCHLD: kill -s SIGCHLD $ppid"
            echo "   💡 If parent is unresponsive, restart or kill parent: kill -15 $ppid"
        else
            echo "   Parent PID $ppid already exited or not accessible."
        fi
    fi
done

