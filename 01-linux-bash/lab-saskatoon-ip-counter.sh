#!/usr/bin/env bash
# ==============================================================================
# lab-saskatoon-ip-counter.sh
# Lab Generator & Solution Checker for SadServers "Saskatoon" Challenge:
# "Counting IPs in access.log to find the highest requester"
# ==============================================================================
set -euo pipefail

LAB_DIR="/tmp/saskatoon"
LOG_FILE="$LAB_DIR/access.log"
SOLUTION_FILE="$LAB_DIR/highestip.txt"

# Target winning frequency
TARGET_COUNT=482

usage() {
    echo "======================================================================"
    echo "🧪 Lab: SadServers 'Saskatoon' - Web Log IP Frequency Counter"
    echo "======================================================================"
    echo "Usage:"
    echo "  $0 --setup      Generate mock /tmp/saskatoon/access.log scenario"
    echo "  $0 --check      Verify your /tmp/saskatoon/highestip.txt solution"
    echo "  $0 --clean      Remove temporary lab files"
    echo "======================================================================"
    exit 1
}

setup_lab() {
    echo "🚀 Setting up Saskatoon practice scenario in '$LAB_DIR'..."
    mkdir -p "$LAB_DIR"

    # Define secret winning IP and distractor IPs
    local WINNER_IP="198.51.100.42"
    local DISTRACTORS=(
        "10.0.4.15" "172.16.88.2" "192.168.1.105" "203.0.113.8"
        "198.51.100.17" "10.0.12.99" "172.24.1.50" "192.168.5.210"
        "203.0.113.77" "10.100.1.3" "172.31.0.8" "192.168.100.4"
    )

    local HTTP_METHODS=("GET" "POST" "PUT" "DELETE" "HEAD")
    local ENDPOINTS=("/api/v1/users" "/index.html" "/static/bundle.js" "/login" "/checkout" "/healthz" "/api/v2/orders")
    local STATUS_CODES=(200 200 200 200 301 304 400 401 403 404 500 502)

    echo "⚙️ Generating realistic web traffic (thousands of lines)..."
    local TEMP_LOG="$LAB_DIR/raw_access.log"
    : > "$TEMP_LOG"

    # 1. Insert Winner IP exactly TARGET_COUNT times (482)
    for ((i=1; i<=TARGET_COUNT; i++)); do
        local method="${HTTP_METHODS[$RANDOM % ${#HTTP_METHODS[@]}]}"
        local endpoint="${ENDPOINTS[$RANDOM % ${#ENDPOINTS[@]}]}"
        local status="${STATUS_CODES[$RANDOM % ${#STATUS_CODES[@]}]}"
        local bytes=$(( RANDOM % 5000 + 100 ))
        echo "$WINNER_IP - - [27/Aug/2026:14:$((i%60)):$((i%60)) +0000] \"$method $endpoint HTTP/1.1\" $status $bytes" >> "$TEMP_LOG"
    done

    # 2. Insert Distractors with counts strictly less than 482
    for ip in "${DISTRACTORS[@]}"; do
        local count=$(( RANDOM % 350 + 50 ))
        for ((j=1; j<=count; j++)); do
            local method="${HTTP_METHODS[$RANDOM % ${#HTTP_METHODS[@]}]}"
            local endpoint="${ENDPOINTS[$RANDOM % ${#ENDPOINTS[@]}]}"
            local status="${STATUS_CODES[$RANDOM % ${#STATUS_CODES[@]}]}"
            local bytes=$(( RANDOM % 5000 + 100 ))
            echo "$ip - - [27/Aug/2026:14:$((j%60)):$((j%60)) +0000] \"$method $endpoint HTTP/1.1\" $status $bytes" >> "$TEMP_LOG"
        done
    done

    # 3. Shuffle all lines so the logs are in chaotic chronological order
    shuf "$TEMP_LOG" > "$LOG_FILE"
    rm -f "$TEMP_LOG"
    rm -f "$SOLUTION_FILE"

    echo ""
    echo "======================================================================"
    echo "✅ Lab Environment Ready!"
    echo "----------------------------------------------------------------------"
    echo "📁 Target Log File:    $LOG_FILE"
    echo "🎯 Expected Output:    $SOLUTION_FILE"
    echo "📊 Total Lines:        $(wc -l < "$LOG_FILE")"
    echo ""
    echo "📋 Mission Requirements:"
    echo "1. Read '$LOG_FILE'."
    echo "2. Identify the IP in the 1st column with the MOST requests."
    echo "3. Write ONLY that IP address into '$SOLUTION_FILE'."
    echo "4. Run '$0 --check' to test your solution."
    echo "======================================================================"
}

check_solution() {
    echo "🔍 Validating solution in '$SOLUTION_FILE'..."
    echo "----------------------------------------------------------------------"

    if [[ ! -f "$SOLUTION_FILE" ]]; then
        echo "❌ ERROR: Solution file '$SOLUTION_FILE' does not exist."
        echo "💡 Hint: Write your answer with: echo 'IP' > $SOLUTION_FILE"
        exit 1
    fi

    # Clean whitespace and extract raw content
    local USER_IP
    USER_IP=$(tr -d '[:space:]' < "$SOLUTION_FILE")

    if [[ -z "$USER_IP" ]]; then
        echo "❌ ERROR: Solution file is empty."
        exit 1
    fi

    if [[ ! -f "$LOG_FILE" ]]; then
        echo "❌ ERROR: Log file '$LOG_FILE' not found. Run '$0 --setup' first."
        exit 1
    fi

    # Count occurrences in log file
    local OCCURRENCES
    OCCURRENCES=$(grep -c -F "$USER_IP" "$LOG_FILE" || true)

    echo "🔎 Analyzing submitted IP: $USER_IP"
    echo "📊 Occurrences found in log: $OCCURRENCES (Target needed: $TARGET_COUNT)"

    if [[ "$OCCURRENCES" -eq "$TARGET_COUNT" ]]; then
        echo ""
        echo "🎉 ==========================================================="
        echo "🎉 SUCCESS! YOU NAILED IT!"
        echo "🎉 The IP '$USER_IP' has the highest frequency ($TARGET_COUNT times)."
        echo "🎉 ==========================================================="
    else
        echo ""
        echo "❌ INCORRECT: The IP '$USER_IP' appeared $OCCURRENCES times instead of $TARGET_COUNT."
        echo "💡 Check your pipeline: field extraction -> sort -> count -> sort numerical -> top 1."
        exit 1
    fi
}

clean_lab() {
    echo "🧹 Cleaning up $LAB_DIR..."
    rm -rf "$LAB_DIR"
    echo "✅ Lab directory removed."
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