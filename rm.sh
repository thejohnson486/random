#!/bin/bash

# Define constants for SSH and command execution
SSH_COMMAND="ssh -i ~/.ssh/id_rsa {}"
RM_COMMAND="rm -rf /var/netwitness/concentrator/index/* && rm -rf /var/netwitness/concentrator/sessiondb/* && rm -rf /var/netwitness/concentrator/metadb/*"
RESTART_COMMAND="systemctl restart nwconcentrator"

# Read list of hosts from input file
hosts_file="hosts.txt"
if [ ! -f "$hosts_file" ]; then
    echo "Error: hosts file '$hosts_file' not found"
    exit 1
fi

# Loop through each host and run commands
while read host; do
    echo "Running commands on host $host..."

    # SSH into host using local SSH keys and run commands
    ssh_command=$(printf "$SSH_COMMAND" "$host")
    ssh "$ssh_command" "$RM_COMMAND"
    ssh "$ssh_command" "$RESTART_COMMAND"

    echo "Finished running commands on host $host"
done < "$hosts_file"
