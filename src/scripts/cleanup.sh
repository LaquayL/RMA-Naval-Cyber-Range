#!/usr/bin/env bash
set -euo pipefail

# ----- CONFIGURATION -----
# List your hosts and their SSH creds here (one per line):
#   hostname_or_ip username password
HOSTS_CFG="${1:-hosts.cfg}"

# -------------------------

if ! command -v sshpass >/dev/null 2>&1; then
  echo "ERROR: sshpass is required (sudo apt install sshpass)" >&2
  exit 1
fi

if [ ! -r "$HOSTS_CFG" ]; then
  echo "Usage: $0 hosts.cfg" >&2
  echo "Each line of hosts.cfg should be: host user password" >&2
  exit 1
fi

while read -r HOST USER PASS; do
    [ -z "$HOST" ] && continue        # skip blank lines
    echo "→ Cleaning up on $HOST as $USER …"

    if sshpass -p "$PASS" ssh -n \
        -o ConnectTimeout=5 \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        "${USER}@${HOST}" \
        'pkill -f I_c0ntro1_y0ur_5hip || true'
        
    then
        echo "  ✔ Success on $HOST"
    else
        echo "  ✖ Failed on $HOST"
    fi

    if sshpass -p "$PASS" ssh -n \
        -o ConnectTimeout=5 \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        "${USER}@${HOST}" \
        'rm -rf "$HOME/.tmp" || true'
        
    then
        echo "  ✔ Success on $HOST"
    else
        echo "  ✖ Failed on $HOST"
    fi

done < "$HOSTS_CFG"
