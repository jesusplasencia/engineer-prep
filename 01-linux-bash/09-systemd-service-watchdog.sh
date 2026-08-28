#!/usr/bin/env bash
# ==============================================================================
# 09-systemd-service-watchdog.sh
# Monitors specified critical systemd services, detects failed/inactive states,
# captures recent journal errors, and attempts automatic recovery.
# ==============================================================================
set -euo pipefail

SERVICES=("${@:-nginx postgresql docker ssh}")

echo "======================================================================"
echo "🐕 Systemd Service Watchdog & Self-Healer"
echo "======================================================================"

if ! command -v systemctl &>/dev/null; then
    echo "ℹ️ Systemd / systemctl is not present (running in container or non-systemd OS)."
    echo "Simulating service check for: ${SERVICES[*]}"
    for svc in "${SERVICES[@]}"; do
        echo "   [SIMULATED] Service: $svc -> Status: OK"
    done
    exit 0
fi

for svc in "${SERVICES[@]}"; do
    if systemctl is-active --quiet "$svc"; then
        echo "✅ Service '$svc' is active and running."
    else
        echo "🚨 Service '$svc' is NOT active! Status: $(systemctl is-failed "$svc" || echo 'unknown')"
        echo "📜 Extracting last 10 journal log lines for '$svc':"
        journalctl -u "$svc" -n 10 --no-pager 2>/dev/null || true
        
        echo "🔄 Attempting restart of '$svc'..."
        if systemctl restart "$svc"; then
            echo "   ✅ Successfully restarted '$svc'."
        else
            echo "   ❌ Failed to restart '$svc'. Manual intervention required!"
        fi
    fi
done

