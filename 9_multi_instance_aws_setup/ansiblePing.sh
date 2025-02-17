#!/bin/bash
ANSIBLE_HOST_KEY_CHECKING=False ansible -i ansible_playbooks/inventory all -m ping
