#!/bin/bash

TYPE_IP_FILE="./ansible_playbooks/type_ips"
INVENTORY_FILE="./ansible_playbooks/inventory"

# Inventardatei leeren
#>"$INVENTORY_FILE"

# Assoziatives Array zur Vermeidung doppelter Gruppen
declare -A seen_groups

while IFS=":" read -r type ip; do
    if [[ -n "$type" && -n "$ip" ]]; then
        # Falls die Gruppe noch nicht existiert, erstelle sie
        if [ -z "${seen_groups[$type]}" ]; then
            echo "" >>"$INVENTORY_FILE"
            echo "[$type]" >>"$INVENTORY_FILE"
            seen_groups[$type]=1
        fi
        echo "$ip" >>"$INVENTORY_FILE"
    fi
done <"$TYPE_IP_FILE"

# Terraform erwartet eine JSON-Ausgabe
echo "{\"status\": \"success\"}"
