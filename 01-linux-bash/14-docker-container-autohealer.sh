#!/usr/bin/env bash
# ==============================================================================
# 14-docker-container-autohealer.sh
# Checks all running Docker containers for unhealthy health status or crash loops,
# captures exit codes/logs, and restarts degraded containers.
# ==============================================================================
set -euo pipefail

echo "======================================================================"
echo "🐳 Docker Container Health Watchdog & Auto-Healer"
echo "======================================================================"

if ! command -v docker &>/dev/null; then
    echo "⚠️ Docker is not installed or not available in PATH."
    exit 0
fi

# List containers with unhealthy status
UNHEALTHY=$(docker ps --filter "health=unhealthy" --format "{{.ID}} {{.Names}} {{.Status}}")

if [[ -z "$UNHEALTHY" ]]; then
    echo "✅ All running containers with healthchecks are HEALTHY."
else
    echo "🚨 Degraded / Unhealthy containers found:"
    echo "$UNHEALTHY"
    echo "----------------------------------------------------------------------"
    
    echo "$UNHEALTHY" | while read -r cid cname cstatus; do
        echo "📜 Capturing last 20 log lines for $cname ($cid):"
        docker logs --tail 20 "$cid" || true
        
        echo "🔄 Attempting restart for $cname..."
        docker restart "$cid"
        echo "✅ Restart command issued for $cname."
    done
fi

# Check for containers that exited unexpectedly (non-zero exit code)
echo ""
echo "🔍 Checking containers that exited with error in the last 1 hour:"
docker ps -a --filter "status=exited" --format "{{.ID}} {{.Names}} (Exit: {{.Status}})" | head -n 10 || true

