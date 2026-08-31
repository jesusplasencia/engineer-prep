#!/usr/bin/env bash
# ==============================================================================
# 03-grep-incident-triage.sh
# Production incident log filtering and triage with grep
# ==============================================================================
set -euo pipefail

SRC="${1:-/tmp/lab-grep/incident.log}"
TARGET="${2:-/tmp/lab-grep/filtered_errors.log}"

# Write your grep pipeline below:
grep -Ei "ERROR|FATAL|critical" "$SRC" | grep -Ev "/healthz|kube-probe" > "$TARGET"