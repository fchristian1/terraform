#!/bin/bash
cd ansible_playbooks/
# ansible-playbook -i inventory nginx.yaml
ansible-playbook -i inventory docker.yaml

# ansible-playbook -i inventory user.yaml
# while IFS= read -r line; do
#     echo "ssh deploy@$line -i ./ansible_playbooks/deploy_id_rsa"
# done <ips
