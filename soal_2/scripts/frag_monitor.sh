#!/bin/bash

LOG_DIR="logs"
FRAG_LOG="$LOG_DIR/fragment.log"

mkdir -p "$LOG_DIR"

timestamp=$(date +"%Y-%m-%d %H:%M:%S")

echo "-----------------------------------------"
echo "            Arcaea Fragment              "
echo "-----------------------------------------"

total_ram=$(grep "MemTotal" /proc/meminfo | awk '{print $2}')
free_ram=$(grep "MemAvailable" /proc/meminfo | awk '{print $2}')
used_ram=$((total_ram - free_ram))
ram_usage_percent=$(( (used_ram * 100) / total_ram ))

total_ram_mb=$((total_ram / 1024))
used_ram_mb=$((used_ram / 1024))
free_ram_mb=$((free_ram / 1024))

echo "Total RAM: ${total_ram_mb} MB"
echo "Used RAM: ${used_ram_mb} MB"
echo "Free RAM: ${free_ram_mb} MB"
echo "RAM Usage: ${ram_usage_percent}%"
echo "========================================="

echo "[$times] - Fragment Usage [$ram_usage_percent%] - Fragment Count [$used_ram_mb MB] - Details [Total: $total_ram_mb MB, Available: $free_ram_mb MB]" >> "$FRAG_LOG"
