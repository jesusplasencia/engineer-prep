#!/usr/bin/env bash
# ==============================================================================
# 04-awk-metric-extractor.sh
# Production API log surgical metrics extraction and filtering with awk
# ==============================================================================
set -euo pipefail

SRC="${1:-/tmp/lab-awk/access_metrics.log}"
TARGET="${2:-/tmp/lab-awk/slow_5xx_summary.txt}"

# Write your awk command / pipeline below:
awk '$4 >= 500 && $5 > 1000 {print $3, $5, $6}' "$SRC" > "$TARGET"