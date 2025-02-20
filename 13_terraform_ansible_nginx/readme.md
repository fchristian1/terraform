# Terrraform AWS Multi Instance Setup
## create a inventoryfile for ansible

login aws cli

```bash
terraform init
terraform apply
```

## Run the ansible scripts

```bash
ansiblePing.sh # to check if the instances are reachable
ansiblePlaybook.sh # to run the playbook
```