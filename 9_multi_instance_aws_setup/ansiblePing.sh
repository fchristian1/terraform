#!/bin/bash
ANSIBLE_HOST_KEY_CHECKING=False cd ansible_playbooks/ && ansible -i inventory all -m ping
