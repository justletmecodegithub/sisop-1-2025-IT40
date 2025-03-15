#!/bin/bash

clear

speak_to_me() {
    while true; do
        clear
        curl -s https://www.affirmations.dev | jq -r '.affirmation'
        sleep 1
    done
}

time_Display() {
    while true; do
        clear
        date "+%Y-%m-%d %H:%M:%S"
        sleep 1
    done
}

on_the_run()  {
	local progress=0
    local bar_length=$(tput cols)
    local filled

    while [ "$progress" -lt 100 ]; do
        clear
        filled=$(( progress * bar_length / 100 ))
        printf "["
        printf "%0.s#" $(seq 1 $filled)
        printf "%0.s-" $(seq $filled $bar_length)
        printf "] %d%%\n" "$progress"
        progress=$(( progress + RANDOM % 10 + 1 ))
        sleep $(awk -v min=0.1 -v max=1 'BEGIN{srand(); print min+rand()*(max-min)}')
    done
}

money() {
	chars=("💲" "€" "£" "¥" "¢" "₹" "₩" "₿" "₣")
	rows=$(tput lines)
	cols=$(tput cols)
	while true; do
    col=$((RANDOM % cols))  # Pick a random column
    char=${chars[$((RANDOM % ${#chars[@]}))]}  # Pick a random character
    tput cup 0 $col  # Move cursor to the top of the column
    echo -ne "\033[32m$char\033[0m"  # Print the character in green

    for ((i=1; i<rows; i++)); do
        tput cup $i $col
        echo -ne "\033[32m$char\033[0m"
        sleep 0.1
    done
done
}

brain_damage() {
    while true; do
        clear
        ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 20
        sleep 1
    done
}

case "$1" in
    --play="Speak to Me")
        speak_to_me
        ;;
    --play="On the Run")
        on_the_run
        ;;
    --play="Time")
        time_Display
        ;;
    --play="Money")
        money
        ;;
    --play="Brain Damage")
        brain_damage
        ;;
    *)
        echo "Usage: ./dsotm.sh --play=\"<Track>\""
        echo "Available Tracks: Speak to Me, On the Run, Time, Money, Brain Damage"
        exit 1
        ;;
esac
