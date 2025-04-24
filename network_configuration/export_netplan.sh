#!/bin/bash

# Default configuration
EVE_HOST="192.168.166.166"
EVE_USER="root"
REMOTE_DIR="/root/export"

# Help message
print_help() {
    echo "Usage: $0 <export_filename.yaml>"
    echo
    echo "Arguments:"
    echo "  <export_filename.yaml>     Name of the YAML file to create on the EVE-NG host"
    echo
    echo "Environment:"
    echo "  This script collects netplan configuration from the current machine and"
    echo "  sends it via SCP to the EVE-NG host at $EVE_HOST (user: $EVE_USER)"
    echo
    echo "Example:"
    echo "  $0 ubuntu-vm1.yaml"
    echo
    exit 0
}

# Check for help flag
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    print_help
fi

# Validate argument
if [ -z "$1" ]; then
    echo "Error: You must provide a filename for the exported YAML file."
    echo "Try '$0 --help' for more information."
    exit 1
fi

EXPORT_NAME="$1"
TMP_FILE="/tmp/$EXPORT_NAME"

# Prompt for password securely
read -s -p "Enter password for $EVE_USER@$EVE_HOST: " EVE_PASS
echo

# Check sshpass is available
if ! command -v sshpass &>/dev/null; then
    echo "Installing sshpass..."
    sudo apt update && sudo apt install -y sshpass
fi

# Combine all netplan YAML files into one (optional: modify as needed)
sudo cat /etc/netplan/*.yaml > "$TMP_FILE"

# Transfer file
echo "Transferring $TMP_FILE to $EVE_USER@$EVE_HOST:$REMOTE_DIR/$EXPORT_NAME"
sshpass -p "$EVE_PASS" scp -o StrictHostKeyChecking=no "$TMP_FILE" "$EVE_USER@$EVE_HOST:$REMOTE_DIR/$EXPORT_NAME"

# Cleanup
rm "$TMP_FILE"
echo "Done. File uploaded to $EVE_HOST:$REMOTE_DIR/$EXPORT_NAME"
