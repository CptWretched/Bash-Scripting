#!/bin/bash
# Define the path to the registers file
REGISTERS_FILE="registers.txt"
# Define an array of IP addresses to connect to
IP_ADDRESSES=()
# Read the IP addresses from the registers file
while read -r line; do
  IP_ADDRESSES+=("$line")
done < "$REGISTERS_FILE"
# Define the username and password for the remote machines
USERNAME="root"
PASSWORD="c0b4lt!"
# Loop through each IP address in the array
for i in "${IP_ADDRESSES[@]}"
do
  # Connect to the remote machine using SSH with sshpass and -T option
  sshpass -p ${PASSWORD} ssh -T ${USERNAME}@${i} << EOF
    echo "Rebooting IP address: $i"
    reboot
EOF
echo "$(date +%m-%d-%Y) | IP Rebooted $i @ $(date +%r)" >> log_file.$(date -I).txt
done