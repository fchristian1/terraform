#!/bin/bash
cd ansible_playbooks/
ansible-playbook -i inventory ping_wait.yaml
