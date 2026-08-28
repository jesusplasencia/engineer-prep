#!/usr/bin/env bash
set -euo pipefail

SRC="${1:-/tmp/saskatoon/access.log}"
TARGET="${2:-/tmp/saskatoon/highestip.txt}"

awk '{print $1}' "$SRC" | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}' > "$TARGET"