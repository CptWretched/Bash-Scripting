#!/bin/bash

# Function for option 1
function option1() {
    echo "Option 1 selected."
    # Add your task here.
    sleep 2 # Simulate some processing time
}

# Function for option 2
function option2() {
    echo "Option 2 selected."
    # Add your task here.
    sleep 2 # Simulate some processing time
}

# Function for exiting the menu
function exit_menu() {
    clear
    dialog --clear --title "Exit" --yesno "\nAre you sure you want to exit?" 5 20
    if [ $? -eq 0 ]; then
        echo "Exiting..."
        exit 0
    else
        main_menu
    fi
}

# Main menu function
function main_menu() {
    while true; do
        exec 3>&1 # Save current stdout

        selection=$(dialog --clear \
            --backtitle "Main Menu" \
            --title "Choose an option:" \
            --menu "Select one of the following options:" 15 50 4 \
            "1" "Option 1" \
            "2" "Option 2" \
            "3" "Exit" 3>&-)

        exec 1>&3 # Restore stdout

        case $selection in
            1)
                option1
                ;;
            2)
                option2
                ;;
            3)
                exit_menu
                break
                ;;
            *)
                dialog --clear --msgbox "Invalid selection. Please try again." 5 20
                ;;
        esac

    done
}

# Start the script with the main menu
main_menu