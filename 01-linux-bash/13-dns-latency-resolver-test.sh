#!/usr/bin/env bash
# ==============================================================================
# 13-dns-latency-resolver-test.sh
# Benchmarks DNS query times and resolution accuracy across multiple nameservers
# (Local /etc/resolv.conf, Cloudflare, Google, Quad9) using dig or drill.
# ==============================================================================
set -euo pipefail

QUERY_DOMAIN="${1:-google.com}"

SERVERS=(
    "System-Default"
    "1.1.1.1 (Cloudflare)"
    "8.8.8.8 (Google)"
    "9.9.9.9 (Quad9)"
)

echo "======================================================================"
echo "🌐 DNS Latency & Resolution Benchmark"
echo "Target Query: $QUERY_DOMAIN"
echo "======================================================================"
printf "%-25s %-15s %-20s %s\n" "NAMESERVER" "QUERY TIME" "RESOLVED IP" "STATUS"
echo "----------------------------------------------------------------------"

if ! command -v dig &>/dev/null; then
    echo "⚠️ 'dig' command not found. Using nslookup fallback..."
    nslookup "$QUERY_DOMAIN"
    exit 0
fi

for s in "${SERVERS[@]}"; do
    server_ip="${s%% *}"
    
    if [[ "$server_ip" == "System-Default" ]]; then
        result=$(dig +noall +stats +answer "$QUERY_DOMAIN" 2>/dev/null || true)
    else
        result=$(dig @"$server_ip" +noall +stats +answer "$QUERY_DOMAIN" 2>/dev/null || true)
    fi

    query_time=$(echo "$result" | awk '/Query time:/ {print $4, $5}')
    resolved_ip=$(echo "$result" | awk '$4 == "A" {print $5}' | head -n 1)

    if [[ -n "$query_time" ]]; then
        printf "%-25s %-15s %-20s \033[0;32mOK\033[0m\n" "$s" "$query_time" "${resolved_ip:-CNAME/Other}"
    else
        printf "%-25s %-15s %-20s \033[0;31mFAILED\033[0m\n" "$s" "TIMEOUT" "N/A"
    fi
done
echo "======================================================================"

