data "external" "generate_ipfile-controller" {
  depends_on = [module.aws-instances-controller]

  program = ["bash", "-c", <<EOT
    FILE="./ansible_playbooks/type_ips"
    > $FILE
    for ip in ${join(" ", module.aws-instances-controller[*].public_ip)}; do
      echo "controller:$ip" > $FILE
    done

    echo "{\"status\": \"success\"}"
  EOT
  ]
}
data "external" "generate_ipfile-proxy" {
  depends_on = [module.aws-instances-proxy, data.external.generate_ipfile-controller]

  program = ["bash", "-c", <<EOT
    FILE="./ansible_playbooks/type_ips"
    
    for ip in ${join(" ", module.aws-instances-proxy[*].public_ip)}; do
      echo "proxy:$ip" >> $FILE
    done

    echo "{\"status\": \"success\"}"
  EOT
  ]
}
data "external" "generate_ipfile-load-balancer" {
  depends_on = [module.aws-instances-load-balancer, data.external.generate_ipfile-proxy]

  program = ["bash", "-c", <<EOT
    FILE="./ansible_playbooks/type_ips"
    
    for ip in ${join(" ", module.aws-instances-load-balancer[*].public_ip)}; do
      echo "load-balancer:$ip" >> $FILE
    done

    echo "{\"status\": \"success\"}"
  EOT
  ]
}
data "external" "generate_ipfile-database" {
  depends_on = [module.aws-instances-database, data.external.generate_ipfile-load-balancer]

  program = ["bash", "-c", <<EOT
    FILE="./ansible_playbooks/type_ips"
    
    for ip in ${join(" ", module.aws-instances-database[*].public_ip)}; do
      echo "database:$ip" >> $FILE
    done

    echo "{\"status\": \"success\"}"
  EOT
  ]
}
data "external" "generate_ipfile-server" {
  depends_on = [module.aws-instances-server, data.external.generate_ipfile-database]

  program = ["bash", "-c", <<EOT
    FILE="./ansible_playbooks/type_ips"
    
    for ip in ${join(" ", module.aws-instances-server[*].public_ip)}; do
      echo "server:$ip" >> $FILE
    done

    echo "{\"status\": \"success\"}"
  EOT
  ]
}

# create a inventory file for ansible in ./ansible_playbook/inventory
data "external" "generate_inventory_first" {
  depends_on = [data.external.generate_ipfile-server]

  program = ["bash", "-c", <<EOT
    INVENTORY_FILE="./ansible_playbooks/inventory"
    echo "[all:vars]" > $INVENTORY_FILE
    echo "ansible_ssh_user=ubuntu" >> $INVENTORY_FILE
    echo "ansible_ssh_private_key_file=my_key.pem" >> $INVENTORY_FILE
    
    echo "{\"status\": \"success\"}"
  EOT
  ]
}
# create a inventory file for ansible from:
# controller:18.153.78.10
# proxy:18.197.69.141
# load-balancer:3.67.11.211
# server:18.185.72.70
# server:3.120.193.237
# use <name>:<ip> format
data "external" "generate_inventory-sec" {
  depends_on = [data.external.generate_inventory_first]

  program = ["bash", "./generate_inventory.sh"]
}






# data "external" "ips_file" {
#   depends_on = [module.aws-instances]

#   program = ["bash", "-c", <<EOT
#     FILE="./ansible_playbooks/ips"
#     echo -n > $FILE
#     for ip in ${join(" ", module.aws-instances[*].public_ip)}; do
#       echo "$ip" >> $FILE
#     done

#     echo "{\"status\": \"success\"}"
#   EOT
#   ]
# }
