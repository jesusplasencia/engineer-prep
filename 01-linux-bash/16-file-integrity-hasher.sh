#!/usr/bin/env bash
# ==============================================================================
# 16-file-integrity-hasher.sh
# Baseline configuration drift detection: creates and verifies SHA-256 integrity
# hashes of critical config directories (/etc, /app/config) to spot tampering.
# ==============================================================================
set -euo pipefail

TARGET_DIR="${1:-/tmp/sample_config}"
BASELINE_DB="${2:-/tmp/config_baseline.sha256}"
ACTION="${3:-check}"  # "init" or "check"

mkdir -p "$TARGET_DIR"

if [[ "$ACTION" == "init" ]] || [[ ! -f "$BASELINE_DB" ]]; then
    echo "======================================================================"
    echo "🔐 Initializing File Integrity Baseline in $BASELINE_DB"
    echo "Target: $TARGET_DIR"
    echo "======================================================================"
    # Create sample file if empty
    echo "setting=true" > "$TARGET_DIR/app.conf"
    find "$TARGET_DIR" -type f -exec sha256sum {} + > "$BASELINE_DB"
    echo "✅ Baseline created with $(wc -l < "$BASELINE_DB") files tracked."
    exit 0
fi

echo "======================================================================"
echo "🔍 Checking Configuration Integrity against Baseline"
echo "======================================================================"

if sha256sum --check --quiet "$BASELINE_DB" 2>/dev/null; then
    echo "✅ All tracked configuration files match their baseline hashes (No drift detected)."
else
    echo "🚨 DRIFT OR TAMPERING DETECTED! Differences:"
    sha256sum --check "$BASELINE_DB" 2>&1 | grep -v 'OK' || true
fi

