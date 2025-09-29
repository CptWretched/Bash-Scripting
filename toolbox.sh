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
        echo "1) Option 1: Register Info"
        echo "2) Option 2: Register List Reboot"
        echo "3) Exit"
        read -p "Select an option [1-3]: " selection

        case $selection in
            1)
                option1
                            USERNAME="root"
            PASSWORD="c0b4lt"  # Consider using SSH keys instead for security.
            read -r -p "Enter IP Address: " IP

            # Use sshpass to pass the password and execute commands remotely
            sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no -T "$USERNAME@$IP" << EOF
                printf "\033[32mHost Name: \033[0m\n" && hostname
                printf "\033[32mCheck OS Version :\033[0m\n";  grep -o 'PRETTY_NAME="[^"]*"' /etc/os-release | sed 's/PRETTY_NAME="//' | sed 's/"$//' && echo && \
                printf "\033[32mCheck the POS Build\033[0m\n"; rpm -qa | grep bean && echo && \
                printf "\033[32mCheck register environment:\033[0m\n"; grep "servletURL" /beanstore-client/pos/global.properties | sed 's/servletURL=//; s/BeanstoreServer//g' && echo && \
                printf "\033[32mCheck the DNS configuration:\033[0m\n"; cat /etc/resolv.conf && echo && \
                printf "\033[32mCheck what NTP servers are being used:\033[0m\n"; grep 'server' /etc/ntp.conf && echo && \
                printf "\033[32mCheck the Aurus URLs being used:\033[0m\n"; grep -E 'primary_url|secondary_url' /beanstore-client/pos/config/aesdkconfig/aesdk-config.properties && echo && \
                printf "\033[32mFind what Aurus Jar files are present:\033[0m\n"; find /beanstore-client/libs/pos_component -type f -exec grep -E 'aurus-aesdk-service' {} \; | sed 's/^.*\/\(.*\)$/\1/' && echo
EOF
                read -p "Press Enter to continue..."
                ;;
            2)
                option2
            
            # Define the path to the registers file
            REGISTERS_FILE="registers.txt"
            # Log script start time
            echo "Script Start" >> log_file."$(date -I)".txt

            # Define the username and password for the remote machines
            USERNAME="root"
            PASSWORD="c0b4lt"

            # Define an array of IP addresses to connect to
            IP_ADDRESSES=()

            # Read the IP addresses from the registers file
            while IFS= read -r line; do
            # Add only valid IPs (optional: can add a regex for validation)
            if [[ "$line" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                IP_ADDRESSES+=("$line")
            fi
            done < "$REGISTERS_FILE"

            # Display the IP addresses from registers.txt
            echo "The following ip addresses will be rebooted:"
            printf "%s\n" "${IP_ADDRESSES[@]}"

            # Prompt the user for confirmation.
            read -p "Is it okay to proceed with the reboots (yes or no)? " input

            # Need to add this into the script | ssh-keyscan -H 172.22.236.22 >> ~/.ssh/known_hosts

            if [[ "$input" == "yes" ]]; then
            # Loop through each IP address in the array
            for i in "${IP_ADDRESSES[@]}"; do
                # Attempt to connect using SSH and capture any errors
                sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no -T "$USERNAME@$i" << EOF
                echo "Rebooting IP address: $i"
                reboot
EOF

            # Check the exit status of the SSH command to determine if there was an error
                ssh_status=$?
                if [ $ssh_status -ne 0 ]; then
                echo "$(date +%m-%d-%Y) | User: $USER | Error connecting to IP: $i @ $(date +%r)" >> log_file."$(date -I)".txt
                else
                # Log the successful reboot action
                echo "$(date +%m-%d-%Y) | User: $USER | IP Rebooted $i @ $(date +%r)" >> log_file."$(date -I)".txt
                fi
            done
            elif [[ "$input" == "no" ]]; then
            echo "Exiting"
            else
            echo "Invalid input, exiting."
            fi

            # Log script end time
            echo "Script End" >> log_file."$(date -I)".txt



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
