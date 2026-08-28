#!/usr/bin/env bash
# ==============================================================================
# 20-chaos-latency-injector.sh
# Chaos Engineering: Uses Linux Traffic Control (tc / netem) to simulate network
# latency, jitter, packet loss, and corruption on target network interfaces.
# ==============================================================================
set -euo pipefail

INTERFACE="${1:-eth0}"
ACTION="${2:-status}" # "add", "del", or "status"
LATENCY_MS="${3:-100ms}"
JITTER_MS="${4:-10ms}"
PACKET_LOSS="${5:-5%}"

echo "======================================================================"
echo "⚡ Chaos Network Injector (tc netem)"
echo "Interface: $INTERFACE | Action: $ACTION"
echo "======================================================================"

if ! command -v tc &>/dev/null; then
    echo "⚠️ 'tc' command (iproute2) is not installed."
    echo "Sample usage commands when tc is installed:"
    echo "  sudo tc qdisc add dev eth0 root netem delay 100ms 10ms loss 5%"
    echo "  sudo tc qdisc del dev eth0 root"
    exit 0
fi

case "$ACTION" in
    add)
        echo "💥 Injecting ${LATENCY_MS} (±${JITTER_MS}) latency and ${PACKET_LOSS} loss on ${INTERFACE}..."
        tc qdisc add dev "$INTERFACE" root netem delay "$LATENCY_MS" "$JITTER_MS" loss "$PACKET_LOSS" || {
            echo "Failed to add qdisc (may already exist). Try running with 'del' first."
        }
        echo "✅ Chaos injected."
        ;;
    del)
        echo "🧹 Removing traffic control rules from ${INTERFACE}..."
        tc qdisc del dev "$INTERFACE" root 2>/dev/null || echo "No active qdisc to remove."
        echo "✅ Interface reset to normal."
        ;;
    status)
        echo "📊 Current qdisc rules on ${INTERFACE}:"
        tc qdisc show dev "$INTERFACE"
        ;;
    *)
        echo "Usage: $0 <interface> [add|del|status] [latency] [jitter] [loss]"
        echo "Example: sudo $0 eth0 add 150ms 20ms 2%"
        exit 1
        ;;
esac

