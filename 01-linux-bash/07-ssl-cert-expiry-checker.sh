#!/usr/bin/env bash
# ==============================================================================
# 07-ssl-cert-expiry-checker.sh
# Connects to TLS/SSL endpoints, extracts expiration dates, and alerts when
# certificates are expiring within N days.
# ==============================================================================
set -euo pipefail

WARN_DAYS="${1:-30}"
shift || true
DOMAINS=("${@:-google.com:443 github.com:443 cloudflare.com:443}")

echo "======================================================================"
echo "🔒 SSL / TLS Certificate Expiry Auditor (Warning: < ${WARN_DAYS} days)"
echo "======================================================================"
printf "%-35s %-25s %-10s %s\n" "ENDPOINT" "EXPIRATION DATE" "DAYS LEFT" "STATUS"
echo "----------------------------------------------------------------------"

for target in $DOMAINS; do
    host="${target%%:*}"
    port="${target##*:}"
    [[ "$host" == "$port" ]] && port=443

    # Extract certificate dates using openssl
    cert_info=$(echo | openssl s_client -servername "$host" -connect "${host}:${port}" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null || true)

    if [[ -z "$cert_info" ]]; then
        printf "%-35s %-25s %-10s \033[0;31mFAILED\033[0m\n" "${host}:${port}" "UNREACHABLE" "N/A"
        continue
    fi

    # Format: notAfter=Jan 15 12:00:00 2027 GMT
    expiry_raw="${cert_info#notAfter=}"
    
    # Calculate days left
    if date -d "$expiry_raw" +%s &>/dev/null; then
        expiry_epoch=$(date -d "$expiry_raw" +%s)
        now_epoch=$(date +%s)
        days_left=$(( (expiry_epoch - now_epoch) / 86400 ))
        
        if (( days_left < 0 )); then
            status="\033[0;31mEXPIRED\033[0m"
        elif (( days_left <= WARN_DAYS )); then
            status="\033[0;33mEXPIRING SOON\033[0m"
        else
            status="\033[0;32mVALID\033[0m"
        fi
        
        printf "%-35s %-25s %-10d %b\n" "${host}:${port}" "$expiry_raw" "$days_left" "$status"
    else
        printf "%-35s %-25s %-10s %s\n" "${host}:${port}" "$expiry_raw" "N/A" "UNKNOWN"
    fi
done

