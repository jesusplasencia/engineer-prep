#!/usr/bin/env bash
# ==============================================================================
# 08-user-permission-auditor.sh
# Audits security risks in permissions: SUID/SGID binaries, world-writable
# files and directories, and unowned files.
# ==============================================================================
set -euo pipefail

SCAN_DIR="${1:-/usr/bin}"

echo "======================================================================"
echo "🛡️ Security & Linux Permission Auditor"
echo "Target Base Directory: $SCAN_DIR"
echo "======================================================================"

echo "1️⃣ Checking SUID / SGID Binaries (Potential Privilege Escalation vectors):"
find "$SCAN_DIR" -maxdepth 3 -type f \( -perm -4000 -o -perm -2000 \) -exec ls -ld {} + 2>/dev/null | head -n 20 || echo "None found."

echo ""
echo "2️⃣ Checking World-Writable Files and Directories:"
find "$SCAN_DIR" -maxdepth 3 -perm -o+w ! -type l -exec ls -ld {} + 2>/dev/null | head -n 20 || echo "None found."

echo ""
echo "3️⃣ Checking for Unowned Files (no user or group):"
find "$SCAN_DIR" -maxdepth 2 \( -nouser -o -nogroup \) -exec ls -ld {} + 2>/dev/null | head -n 10 || echo "None found."

echo ""
echo "✅ Security permission audit completed."

