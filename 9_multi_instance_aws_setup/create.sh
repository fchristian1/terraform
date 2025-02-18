#!/bin/bash
terraform init -upgrade && terraform apply -auto-approve && ./ansible-Ping.sh && ./ansiblePlay.sh
