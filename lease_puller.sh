#!/bin/bash
# ASUS RT-AX55 Lease Puller
# Kelly Shaw and Gem Ini
# April 20, 2025
#
# Description:
# Run from an SSH console on the router. Check the output file for the static
# leases that may exist on the router.

# Input and output file paths
DNSMASQ_CONF="/etc/dnsmasq.conf"  # Replace with your actual dnsmasq.conf file path
OUTPUT_FILE="formatted_leases.conf"

# Check if the input file exists
if [ ! -f "$DNSMASQ_CONF" ]; then
    echo "Error: File '$DNSMASQ_CONF' not found."
    exit 1
fi

# Clear or create the output file
> "$OUTPUT_FILE"

# Parse the dnsmasq.conf file line by line
while IFS= read -r line; do
    case "$line" in
        dhcp-host=*,*,*)
            # Extract MAC, IP, and Hostname
            MAC=$(echo "$line" | cut -d'=' -f2 | cut -d',' -f1)
            IP=$(echo "$line" | cut -d',' -f2)
            HOSTNAME=$(echo "$line" | cut -d',' -f3)
            echo "dhcp-host=$MAC,$IP,$HOSTNAME" >> "$OUTPUT_FILE"
            ;;
        dhcp-host=*,*)
            # Extract MAC and IP (no hostname)
            MAC=$(echo "$line" | cut -d'=' -f2 | cut -d',' -f1)
            IP=$(echo "$line" | cut -d',' -f2)
            echo "dhcp-host=$MAC,$IP" >> "$OUTPUT_FILE"
            ;;
    esac
done < "$DNSMASQ_CONF"

echo "Static DHCP leases formatted and saved to '$OUTPUT_FILE'."