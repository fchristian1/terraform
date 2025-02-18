#!/bin/bash
cd ansible_playbooks/ && ansible -i inventory all -m ping
