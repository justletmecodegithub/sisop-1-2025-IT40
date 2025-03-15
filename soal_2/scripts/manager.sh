#!/bin/bash

CORE_SCRIPTS="./scripts/core_monitor.sh"
FRAG_SCRIPTS="./scripts/frag_monitor.sh"

show_menu() {
    echo "--------------------------------------------"
    echo "              CRONTAB MANAGER      "
    echo "--------------------------------------------"
    echo "1. Add CPU [Core] Usage Monitoring"
    echo "2. Remove CPU [Core] Usage Monitoring"
    echo "3. Add RAM [Fragment] Usage Monitoring"
    echo "4. Remove RAM [Fragment] Usage Monitoring"
    echo "5. View Active Cron Jobs"
    echo "6. Exit"
    echo "--------------------------------------------"
    echo -n "Enter option [1-6]: "
}

add_cron_job() {
    local script_data="$1"
    local job_command="* * * * * /bin/bash $script_data"

    if crontab -l | grep -q "$script_data"; then
        echo "Error: Monitoring for $script_data is already active!"
    else
        (crontab -l 2>/dev/null; echo "$job_command") | crontab -
        echo "Successfully added monitoring for $script_data!"
    fi
}

remove_cron_job() {
    local script_data="$1"

    if crontab -l | grep -q "$script_data"; then
        crontab -l | grep -v "$script_data" | crontab -
        echo "Successfully removed monitoring for $script_data!"
    else
        echo "Error: No monitoring found for $script_data!"
    fi
}

view_active_jobs() {
    echo "Current active cron jobs:"
    crontab -l
}

while true; do
    show_menu
    read option
    case $option in
        1) add_cron_job "$CORE_SCRIPTS" ;;
        2) remove_cron_job "$CORE_SCRIPTS" ;;
        3) add_cron_job "$FRAG_SCRIPTS" ;;
        4) remove_cron_job "$FRAG_SCRIPTS" ;;
        5) view_active_jobs ;;
        6) echo "Exiting Crontab Manager."; exit 0 ;;
        *) echo "Invalid option! Please enter a number between 1-6." ;;
    esac
done
