#!/usr/bin/env bash
# ==============================================================================
# lab-saint-john-log-writer.sh
# Lab Generator & Solution Checker for SadServers "Saint John" Challenge:
# "what is writing to this log file?"
# ==============================================================================
set -euo pipefail

LAB_DIR="/tmp/saint-john"
LOG_FILE="$LAB_DIR/bad.log"
PID_FILE="$LAB_DIR/.bad_service.pid"
DAEMON_SCRIPT="$LAB_DIR/rogue_writer.sh"

usage() {
    echo "======================================================================"
    echo "🧪 Lab: SadServers 'Saint John' - Rogue Process Log Writer Inspector"
    echo "======================================================================"
    echo "Usage:"
    echo "  $0 --setup      Launch rogue background process spamming $LOG_FILE"
    echo "  $0 --check      Verify if the rogue process was identified and stopped"
    echo "  $0 --clean      Stop background processes and remove lab files"
    echo "======================================================================"
    exit 1
}

setup_lab() {
    echo "🚀 Setting up Saint John practice scenario in '$LAB_DIR'..."
    mkdir -p "$LAB_DIR"

    # Stop any existing rogue process first
    clean_processes

    echo "⚙️ Creating rogue daemon script '$DAEMON_SCRIPT'..."
    cat << 'EOF' > "$DAEMON_SCRIPT"
#!/usr/bin/env bash
# Rogue service writing non-stop error traces with persistent file descriptor
exec 3>> /tmp/saint-john/bad.log
while true; do
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] [rogue-worker-$$] Disk space leak simulation payload: $(head -c 64 /dev/urandom | base64)" >&3
    sleep 0.5
done
EOF
    chmod +x "$DAEMON_SCRIPT"

    echo "🔥 Starting background rogue daemon..."
    nohup "$DAEMON_SCRIPT" > /dev/null 2>&1 &
    local DAEMON_PID=$!
    echo "$DAEMON_PID" > "$PID_FILE"
    sleep 1

    if ! kill -0 "$DAEMON_PID" 2>/dev/null; then
        echo "❌ ERROR: Failed to start rogue daemon process."
        exit 1
    fi

    echo ""
    echo "======================================================================"
    echo "✅ Lab Environment Ready & Active!"
    echo "----------------------------------------------------------------------"
    echo "📁 Spamming Log File:   $LOG_FILE"
    echo "📈 Current Log Size:    $(wc -c < "$LOG_FILE" 2>/dev/null || echo 0) bytes"
    echo "👻 Rogue Process Status: RUNNING in background"
    echo ""
    echo "📋 Mission Requirements:"
    echo "1. Identify the PID of the rogue process writing to '$LOG_FILE'."
    echo "2. Inspect the process details in '/proc/<PID>/cmdline' or with 'ps'."
    echo "3. Terminate/kill the rogue process."
    echo "4. (Optional) Truncate or clean the log file to recover disk space."
    echo "5. Run '$0 --check' to verify that the file descriptor is released."
    echo "======================================================================"
}

check_solution() {
    echo "🔍 Validating Saint John solution for '$LOG_FILE'..."
    echo "----------------------------------------------------------------------"

    if [[ ! -d "$LAB_DIR" ]]; then
        echo "❌ ERROR: Lab directory '$LAB_DIR' does not exist. Run '$0 --setup' first."
        exit 1
    fi

    local WRITER_PIDS=""

    # Check 1: Using fuser if available
    if command -v fuser &>/dev/null && [[ -f "$LOG_FILE" ]]; then
        WRITER_PIDS=$(fuser "$LOG_FILE" 2>/dev/null || true)
    fi

    # Check 2: Using lsof if available and fuser didn't find anything
    if [[ -z "$WRITER_PIDS" ]] && command -v lsof &>/dev/null && [[ -f "$LOG_FILE" ]]; then
        WRITER_PIDS=$(lsof -t "$LOG_FILE" 2>/dev/null || true)
    fi

    # Check 3: Check /proc filesystem for open file descriptors pointing to bad.log (including deleted)
    if [[ -z "$WRITER_PIDS" ]]; then
        WRITER_PIDS=$(find /proc/[0-9]*/fd -lname "*$LOG_FILE*" 2>/dev/null | cut -d'/' -f3 | sort -u || true)
    fi

    # Check 4: Measure file growth over 1.5 seconds if file exists
    local GROWTH=0
    if [[ -f "$LOG_FILE" ]]; then
        local SIZE_A
        local SIZE_B
        SIZE_A=$(wc -c < "$LOG_FILE")
        sleep 1.2
        SIZE_B=$(wc -c < "$LOG_FILE")
        GROWTH=$(( SIZE_B - SIZE_A ))
    fi

    if [[ -n "$WRITER_PIDS" || "$GROWTH" -gt 0 ]]; then
        echo "❌ FAILED: The log file is STILL being written to or held open!"
        if [[ -n "$WRITER_PIDS" ]]; then
            echo "   ⚠️ Active Writer PID(s) detected: $WRITER_PIDS"
        fi
        if [[ "$GROWTH" -gt 0 ]]; then
            echo "   ⚠️ File grew by $GROWTH bytes during check window."
        fi
        echo ""
        echo "💡 SRE Tips:"
        echo "   - Find process:  fuser -v $LOG_FILE  OR  lsof $LOG_FILE"
        echo "   - Terminate it:  kill -15 <PID>      OR  fuser -k -9 $LOG_FILE"
        exit 1
    else
        echo "🔎 File Descriptor check: NO active processes holding '$LOG_FILE'."
        echo "📊 Growth check: File size is stable."
        echo ""
        echo "🎉 ==========================================================="
        echo "🎉 SUCCESS! YOU NAILED IT!"
        echo "🎉 The rogue writer process has been completely terminated."
        echo "🎉 File descriptor released and disk space leak stopped."
        echo "🎉 ==========================================================="
    fi
}

clean_processes() {
    # Kill process recorded in PID file if exists
    if [[ -f "$PID_FILE" ]]; then
        local OLD_PID
        OLD_PID=$(cat "$PID_FILE" 2>/dev/null || true)
        if [[ -n "$OLD_PID" ]] && kill -0 "$OLD_PID" 2>/dev/null; then
            echo "🛑 Stopping recorded rogue PID $OLD_PID..."
            kill -9 "$OLD_PID" 2>/dev/null || true
        fi
        rm -f "$PID_FILE"
    fi

    # Kill any rogue_writer process running
    pkill -9 -f "rogue_writer.sh" 2>/dev/null || true
}

clean_lab() {
    echo "🧹 Cleaning up Saint John lab in $LAB_DIR..."
    clean_processes
    rm -rf "$LAB_DIR"
    echo "✅ Lab environment cleaned and all background processes stopped."
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