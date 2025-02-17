#!/bin/bash

ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible_playbooks/inventory ansible_playbooks/nginx.yaml
