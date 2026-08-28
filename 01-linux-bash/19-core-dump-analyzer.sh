#!/usr/bin/env bash
# ==============================================================================
# 19-core-dump-analyzer.sh
# Inspects system coredump directories and coredumpctl to retrieve application
# crash dumps, crash signals (SIGSEGV, SIGABRT), and generates gdb backtraces.
# ==============================================================================
set -euo pipefail

echo "======================================================================"
echo "💥 Application Crash & Core Dump Analyzer"
echo "======================================================================"

# Check coredumpctl if available
if command -v coredumpctl &>/dev/null; then
    echo "1️⃣ Querying coredumpctl for recent crashes:"
    coredumpctl list --no-pager -n 5 || true
    echo ""
    echo "💡 To inspect the latest crash with gdb:"
    echo "   coredumpctl gdb"
    echo "💡 To view stack trace of the latest crash:"
    echo "   coredumpctl info"
fi

# Check /var/crash or /tmp core dumps
echo ""
echo "2️⃣ Scanning filesystem for core dump files (*core*)..."
CORE_FILES=$(find /var/crash /tmp /var/lib/systemd/coredump -type f -name "*core*" 2>/dev/null | head -n 10 || true)

if [[ -n "$CORE_FILES" ]]; then
    echo "Found core files:"
    echo "$CORE_FILES"
else
    echo "ℹ️ No raw core files found in standard locations."
fi

# Check core pattern sysctl
if [[ -f /proc/sys/kernel/core_pattern ]]; then
    echo ""
    echo "ℹ️ Kernel core pattern: $(cat /proc/sys/kernel/core_pattern)"
fi

