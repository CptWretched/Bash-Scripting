#!/bin/bash

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

