#!/bin/bash

# Function for option 1 | Reboot IPs from registers.txt
function option1() {
    echo "Option 1 selected."
    # Add logic to reboot IPs here.
}

# Function for option 2 | Placeholder function
function option2() {
    echo "Option 2 selected."
    # Additional code for option2...
}

# Display menu and get user input
function display_menu() {
    while true; do
        clear
        echo "Main Menu"
        echo "1) Option 1: Reboot IPs"
        echo "2) Option 2: Placeholder"
        echo "3) Exit"
        read -p "Select an option [1-3]: " selection

        case $selection in
            1)
                option1
                ;;
            2)
                option2
                ;;
            3)
                echo "Exiting."
                exit 0
                ;;
            *)
                echo "Invalid selection. Please try again."
                sleep 2
                ;;
        esac
    done
}

# Main script execution
display_menu