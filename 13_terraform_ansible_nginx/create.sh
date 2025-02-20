#!/bin/bash
terraform init -upgrade && terraform apply -auto-approve && sleep 5 && ./ansible-Ping.sh && ./ansiblePlay.sh
