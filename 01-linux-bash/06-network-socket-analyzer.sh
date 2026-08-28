#!/usr/bin/env bash
# ==============================================================================
# 06-network-socket-analyzer.sh
# Analyzes network socket distribution, audits TIME_WAIT, CLOSE_WAIT, and ESTAB
# states to troubleshoot socket exhaustion and file descriptor leaks.
# ==============================================================================
set -euo pipefail

echo "======================================================================"
echo "🌐 Network Socket State Distribution & Exhaustion Analyzer"
echo "======================================================================"

if command -v ss &>/dev/null; then
    echo "📊 Socket Summary (ss -s):"
    ss -s
    echo ""
    echo "📊 TCP Socket State Breakdown:"
    ss -tan | awk 'NR>1 {print $1}' | sort | uniq -c | sort -nr
    echo ""
    
    # Check for excessive CLOSE_WAIT (indicates application failed to call close())
    CLOSE_WAIT_COUNT=$(ss -tan state close-wait | wc -l)
    if [[ "$CLOSE_WAIT_COUNT" -gt 50 ]]; then
        echo "🚨 WARNING: High CLOSE_WAIT sockets ($CLOSE_WAIT_COUNT). Process may have a connection leak!"
        echo "Top processes holding CLOSE_WAIT:"
        ss -tanp state close-wait | awk '{print $NF}' | sort | uniq -c | sort -nr | head -n 10
    fi
    
    # Check for excessive TIME_WAIT (high connection churn)
    TIME_WAIT_COUNT=$(ss -tan state time-wait | wc -l)
    echo "ℹ️ Active TIME_WAIT sockets: $TIME_WAIT_COUNT (Check tcp_tw_reuse if exhaustion occurs)"
    
elif command -v netstat &>/dev/null; then
    echo "📊 TCP Socket State Breakdown (netstat):"
    netstat -tan | awk 'NR>2 {print $6}' | sort | uniq -c | sort -nr
else
    echo "⚠️ Neither 'ss' nor 'netstat' is available on this system."
    exit 1
fi

