#!/bin/bash

LOG_DIR="logs"
CORE_LOG="$LOG_DIR/core.log"

mkdir -p "$LOG_DIR"

times=$(date +"%Y-%m-%d %H:%M:%S")

echo "------------------------------------------"
echo "               Arcaea Core                "
echo "------------------------------------------"

cpu_usage=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}')
cpu_model=$(grep "model name" /proc/cpuinfo | awk -F ':' 'NR==1 {print $2}'| awk '{$1=$1; print}')

echo "Terminal: $cpu_model"
echo "Core Usage: $cpu_usage%"
echo "======================================"

echo "[$times] - Core Usage [$cpu_usage%] - Terminal Model [$cpu_model]" >> "$CORE_LOG"

./scripts/frag_monitor.sh
