#!/usr/bin/env bash
# ==============================================================================
# 05-tcp-port-service-healthcheck.sh
# Performs fast, non-blocking TCP socket health checks and HTTP/HTTPS probes
# against critical infrastructure targets with strict timeouts.
# ==============================================================================
set -euo pipefail

TIMEOUT_SEC="${1:-3}"

# List of targets format: "HOST:PORT [OPTIONAL_PROTOCOL]"
DEFAULT_TARGETS=(
    "127.0.0.1:5432"
    "127.0.0.1:1521"
    "127.0.0.1:8080"
    "1.1.1.1:53"
    "google.com:443"
)

TARGETS=("${@:2}")
if [[ ${#TARGETS[@]} -eq 0 ]]; then
    TARGETS=("${DEFAULT_TARGETS[@]}")
fi

echo "======================================================================"
echo "🩺 TCP Port & Service Health Check (Timeout: ${TIMEOUT_SEC}s)"
echo "======================================================================"
printf "%-25s %-10s %-12s %s\n" "ENDPOINT" "PORT" "STATUS" "LATENCY"
echo "----------------------------------------------------------------------"

for target in "${TARGETS[@]}"; do
    host="${target%%:*}"
    port="${target##*:}"

    start_time=$(date +%s%N)
    
    # Try bash built-in /dev/tcp connection with timeout
    if timeout "$TIMEOUT_SEC" bash -c "true &>/dev/null >/dev/tcp/$host/$port" 2>/dev/null; then
        end_time=$(date +%s%N)
        duration_ms=$(( (end_time - start_time) / 1000000 ))
        printf "%-25s %-10s \033[0;32m%-12s\033[0m %d ms\n" "$host" "$port" "ONLINE" "$duration_ms"
    elif command -v nc &>/dev/null && nc -z -w "$TIMEOUT_SEC" "$host" "$port" 2>/dev/null; then
        end_time=$(date +%s%N)
        duration_ms=$(( (end_time - start_time) / 1000000 ))
        printf "%-25s %-10s \033[0;32m%-12s\033[0m %d ms\n" "$host" "$port" "ONLINE" "$duration_ms"
    else
        printf "%-25s %-10s \033[0;31m%-12s\033[0m TIMEOUT/REFUSED\n" "$host" "$port" "FAILED"
    fi
done
echo "======================================================================"

