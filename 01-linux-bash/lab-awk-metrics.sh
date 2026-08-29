#!/usr/bin/env bash
# ==============================================================================
# lab-awk-metrics.sh
# Lab Generator & Checker for Awk Mastery: SRE Latency & HTTP Error Surgery
# ==============================================================================
set -euo pipefail

LAB_DIR="/tmp/lab-awk"
LOG_FILE="$LAB_DIR/access_metrics.log"
OUTPUT_FILE="$LAB_DIR/slow_5xx_summary.txt"

usage() {
    echo "======================================================================"
    echo "🧪 Lab: SRE Metric Surgery with 'awk'"
    echo "======================================================================"
    echo "Usage:"
    echo "  $0 --setup      Generate access metrics log in $LOG_FILE"
    echo "  $0 --check      Validate extracted slow 5xx errors in $OUTPUT_FILE"
    echo "  $0 --clean      Remove $LAB_DIR"
    echo "======================================================================"
    exit 1
}

setup_lab() {
    echo "🚀 Setting up Awk Metrics Lab in '$LAB_DIR'..."
    mkdir -p "$LAB_DIR"
    rm -f "$OUTPUT_FILE"

    echo "⚙️ Generating access metrics log (format: IP METHOD PATH STATUS LATENCY_MS USER_ID)..."
    : > "$LOG_FILE"

    local ENDPOINTS=("/api/v1/login" "/api/v1/checkout" "/api/v2/orders" "/api/v1/users" "/api/v1/search")
    local METHODS=("GET" "POST" "PUT" "DELETE")

    # Generate 1500 regular normal requests (Status 200/304, latency 20-300ms)
    for i in {1..1500}; do
        local ip="192.168.1.$((RANDOM % 250 + 1))"
        local method="${METHODS[$RANDOM % ${#METHODS[@]}]}"
        local path="${ENDPOINTS[$RANDOM % ${#ENDPOINTS[@]}]}"
        local status=200
        [[ $((i % 5)) -eq 0 ]] && status=304
        local latency=$((RANDOM % 280 + 20))
        echo "$ip $method $path $status $latency user_$i" >> "$LOG_FILE"
    done

    # Generate 30 Fast 5xx errors (Status 500, latency < 1000ms -> should NOT be included)
    for i in {1..30}; do
        local ip="10.0.0.$((RANDOM % 50 + 1))"
        local path="${ENDPOINTS[$RANDOM % ${#ENDPOINTS[@]}]}"
        local latency=$((RANDOM % 400 + 50))
        echo "$ip POST $path 500 $latency user_fast5xx_$i" >> "$LOG_FILE"
    done

    # Generate 30 Slow 200 requests (Status 200, latency > 1000ms -> should NOT be included)
    for i in {1..30}; do
        local ip="10.0.0.$((RANDOM % 50 + 1))"
        local path="${ENDPOINTS[$RANDOM % ${#ENDPOINTS[@]}]}"
        local latency=$((RANDOM % 2000 + 1050))
        echo "$ip GET $path 200 $latency user_slow200_$i" >> "$LOG_FILE"
    done

    # Generate exactly 25 CRITICAL SLOW 5xx errors (Status >= 500 AND latency > 1000ms -> TARGET!)
    for i in {1..25}; do
        local ip="172.16.0.$((RANDOM % 100 + 1))"
        local status=500
        [[ $((i % 2)) -eq 0 ]] && status=502
        [[ $((i % 5)) -eq 0 ]] && status=504
        local latency=$((1500 + i * 20))
        echo "$ip POST /api/v1/checkout $status $latency user_critical_$i" >> "$LOG_FILE"
    done

    # Shuffle
    local SHUFFLED="$LAB_DIR/shuffled.log"
    shuf "$LOG_FILE" > "$SHUFFLED"
    mv "$SHUFFLED" "$LOG_FILE"

    echo ""
    echo "======================================================================"
    echo "✅ Lab Ready!"
    echo "----------------------------------------------------------------------"
    echo "📁 Source Log:         $LOG_FILE"
    echo "🎯 Destination File:   $OUTPUT_FILE"
    echo "📊 Total Rows:         $(wc -l < "$LOG_FILE")"
    echo ""
    echo "📋 Mission Requirements:"
    echo "Log columns are: \$1=IP, \$2=METHOD, \$3=PATH, \$4=STATUS, \$5=LATENCY_MS, \$6=USER_ID"
    echo "1. Filter rows where STATUS >= 500 AND LATENCY_MS > 1000."
    echo "2. Output ONLY 3 columns in this exact format: PATH LATENCY_MS USER_ID"
    echo "   (Example line: /api/v1/checkout 1520 user_critical_1)"
    echo "3. Save the results into '$OUTPUT_FILE'."
    echo "4. Run '$0 --check' to verify your solution."
    echo "======================================================================"
}

check_solution() {
    echo "🔍 Validating '$OUTPUT_FILE'..."
    echo "----------------------------------------------------------------------"

    if [[ ! -f "$OUTPUT_FILE" ]]; then
        echo "❌ ERROR: File '$OUTPUT_FILE' does not exist."
        exit 1
    fi

    local LINE_COUNT
    LINE_COUNT=$(wc -l < "$OUTPUT_FILE" | tr -d ' ')

    echo "📊 Records extracted: $LINE_COUNT (Target expected: 25)"

    # Verify column count per line (must be exactly 3 columns)
    local BAD_COLS
    BAD_COLS=$(awk 'NF != 3 {print NR}' "$OUTPUT_FILE" | wc -l | tr -d ' ')

    if [[ "$BAD_COLS" -gt 0 ]]; then
        echo "❌ FAILED: Each line must have exactly 3 columns: PATH LATENCY_MS USER_ID"
        echo "💡 Hint: awk '\$4 >= 500 && \$5 > 1000 {print \$3, \$5, \$6}'"
        exit 1
    fi

    if [[ "$LINE_COUNT" -eq 25 ]]; then
        echo ""
        echo "🎉 ==========================================================="
        echo "🎉 SUCCESS! You mastered conditional column filtering in 'awk'!"
        echo "🎉 Exactly 25 slow 5xx incident records extracted with precision."
        echo "🎉 ==========================================================="
    else
        echo "❌ FAILED: Expected 25 rows matching both conditions, got $LINE_COUNT."
        exit 1
    fi
}

clean_lab() {
    echo "🧹 Cleaning up $LAB_DIR..."
    rm -rf "$LAB_DIR"
    echo "✅ Awk Lab cleaned."
}

case "${1:-}" in
    --setup)
        setup_lab
        ;;
    --check)
        check_solution
        ;;
    --clean)
        clean_lab
        ;;
    *)
        usage
        ;;
esac