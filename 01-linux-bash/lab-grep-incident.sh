#!/usr/bin/env bash
# ==============================================================================
# lab-grep-incident.sh
# Lab Generator & Checker for Grep Mastery: SRE Production Incident Log Triage
# ==============================================================================
set -euo pipefail

LAB_DIR="/tmp/lab-grep"
LOG_FILE="$LAB_DIR/incident.log"
OUTPUT_FILE="$LAB_DIR/filtered_errors.log"

usage() {
    echo "======================================================================"
    echo "🧪 Lab: SRE Log Triage with 'grep'"
    echo "======================================================================"
    echo "Usage:"
    echo "  $0 --setup      Generate incident log in $LOG_FILE"
    echo "  $0 --check      Validate filtered errors in $OUTPUT_FILE"
    echo "  $0 --clean      Remove $LAB_DIR"
    echo "======================================================================"
    exit 1
}

setup_lab() {
    echo "🚀 Setting up Grep Incident Lab in '$LAB_DIR'..."
    mkdir -p "$LAB_DIR"
    rm -f "$OUTPUT_FILE"

    echo "⚙️ Generating noisy production incident log (2,000+ lines)..."
    : > "$LOG_FILE"

    local SERVICES=("auth-api" "payment-service" "order-worker" "notification-svc" "gateway")
    local NOISE_PATHS=("/healthz" "/livez" "/readyz" "/metrics" "/ping")

    # Generate 1800 lines of noisy info/debug/healthcheck logs
    for i in {1..1800}; do
        local svc="${SERVICES[$RANDOM % ${#SERVICES[@]}]}"
        local path="${NOISE_PATHS[$RANDOM % ${#NOISE_PATHS[@]}]}"
        local level="INFO"
        [[ $((i % 4)) -eq 0 ]] && level="DEBUG"
        [[ $((i % 7)) -eq 0 ]] && level="WARN"
        echo "[2026-08-29 14:$((i%60)):$((i%60))] [$level] [$svc] Healthcheck probe from kubelet on $path HTTP/1.1 200" >> "$LOG_FILE"
    done

    # Generate exactly 42 critical incident error lines with varied casing (ERROR, FATAL, critical)
    # Some critical errors accidentally contain /healthz (e.g. false alarms), but real incident lines are non-healthcheck
    for i in {1..42}; do
        local svc="${SERVICES[$RANDOM % ${#SERVICES[@]}]}"
        local tag="ERROR"
        [[ $((i % 2)) -eq 0 ]] && tag="FATAL"
        [[ $((i % 3)) -eq 0 ]] && tag="critical"
        echo "[2026-08-29 14:$((i%60)):$((i%60))] [$tag] [$svc] Connection pool exhausted during transaction TxID-$((i * 103))" >> "$LOG_FILE"
    done

    # Insert 15 noise error lines that MUST be ignored (healthcheck warnings/timeouts)
    for i in {1..15}; do
        echo "[2026-08-29 14:$((i%60)):$((i%60))] [ERROR] [kube-probe] Probe timeout on /healthz endpoint after 5000ms" >> "$LOG_FILE"
    done

    # Shuffle for realistic log chaos
    local SHUFFLED="$LAB_DIR/shuffled.log"
    shuf "$LOG_FILE" > "$SHUFFLED"
    mv "$SHUFFLED" "$LOG_FILE"

    echo ""
    echo "======================================================================"
    echo "✅ Lab Ready!"
    echo "----------------------------------------------------------------------"
    echo "📁 Source Log:         $LOG_FILE"
    echo "🎯 Destination File:   $OUTPUT_FILE"
    echo "📊 Total Lines:        $(wc -l < "$LOG_FILE")"
    echo ""
    echo "📋 Mission Requirements:"
    echo "1. Read '$LOG_FILE'."
    echo "2. Case-insensitively filter lines containing 'ERROR', 'FATAL', or 'critical'."
    echo "3. EXCLUDE all lines containing health checks ('/healthz' or 'kube-probe')."
    echo "4. Save the resulting incident lines into '$OUTPUT_FILE'."
    echo "5. Run '$0 --check' to verify your solution."
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

    echo "📊 Lines extracted: $LINE_COUNT (Target expected: 42)"

    # Check if any forbidden healthcheck leaked through
    local LEAKED_NOISE
    LEAKED_NOISE=$(grep -E 'healthz|kube-probe' "$OUTPUT_FILE" | wc -l | tr -d ' ')

    if [[ "$LEAKED_NOISE" -gt 0 ]]; then
        echo "❌ FAILED: Found $LEAKED_NOISE noise lines with healthcheck probes. Use 'grep -v' to exclude them."
        exit 1
    fi

    if [[ "$LINE_COUNT" -eq 42 ]]; then
        echo ""
        echo "🎉 ==========================================================="
        echo "🎉 SUCCESS! You mastered 'grep' pattern matching and filtering!"
        echo "🎉 Exactly 42 critical incident records isolated cleanly."
        echo "🎉 ==========================================================="
    else
        echo "❌ FAILED: Expected 42 incident lines, got $LINE_COUNT."
        echo "💡 Hint: Check case-insensitive regex (-i, -E) and inverted match (-v)."
        exit 1
    fi
}

clean_lab() {
    echo "🧹 Cleaning up $LAB_DIR..."
    rm -rf "$LAB_DIR"
    echo "✅ Grep Lab cleaned."
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