#!/bin/bash
cd ansible_playbooks/
# ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory nginx.yaml
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory user.yaml

#for over the file "ips" to echo ssh command

while IFS= read -r line; do
    echo "ssh deploy@$line -i ./ansible_playbooks/deploy_id_rsa"
done <ips
