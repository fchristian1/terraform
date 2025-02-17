#!/bin/bash
ansible -i ansible_playbooks/inventory all -m ping
