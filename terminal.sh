#!/bin/bash

DATABASE="data/player.csv"

show_main_menu() {
    clear
    echo "-------------------------------"
    echo "|            ARCAEA           |"
    echo "-------------------------------"
    echo "| ID |         OPTION         |"
    echo "|----|------------------------|"
    echo "|  1 | Register               |"
    echo "|  2 | Login                  |"
    echo "|  3 | Exit                   |"
    echo "-------------------------------"
    echo -n "Enter option [1-3]: "
    read option

    case $option in
        1) register_user ;;
        2) login_user ;;
        3) exit 0 ;;
        *) echo "Invalid option. Try again."; sleep 2; show_main_menu ;;
    esac
}

register_user() {
    echo -n "Enter your email: "
    read email
    echo -n "Enter your username: "
    read username
    echo -n "Enter password: "
    read -s password
    echo ""

    ./register.sh "$email" "$username" "$password"
    echo "Press Enter to continue..."
    read
    show_main_menu
}

login_user() {
    echo -n "Enter your email: "
    read email
    echo -n "Enter password: "
    read -s password
    echo ""

    ./login.sh "$email" "$password"
    if [ $? -eq 0 ]; then
        show_login_info
        show_login_menu
    else
        echo "Login failed. Please try again."
        echo "Press Enter to continue..."
        read
        show_main_menu
    fi
}

show_login_info() {
    clear
    echo "==================================="
    echo "           LOGIN SUCCESS           "
    echo "==================================="

    ./scripts/core_monitor.sh

    echo "Press Enter to continue..."
    read
}

show_login_menu() {
    clear
    echo "-------------------------------"
    echo "            ARCAEA             "
    echo "-------------------------------"
    echo "| ID |         OPTION         |"
    echo "|----|------------------------|"
    echo "|  1 | Crontab Manager        |"
    echo "|  2 | Exit                   |"
    echo "-------------------------------"
    echo -n "Enter option [1-2]: "
    read option

    case $option in
        1) show_crontab ;;
        2) show_main_menu ;;
        *) echo "Invalid option. Try again."; sleep 2; show_login_menu ;;
    esac
}

show_crontab() {
    ./scripts/manager.sh
    echo "Press Enter to continue..."
    read
    show_login_menu
}

show_main_menu
