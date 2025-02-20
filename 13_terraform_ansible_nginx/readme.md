# Terrraform AWS Multi Instance Setup
## create a inventoryfile for ansible

login aws cli

```bash
terraform init
terraform apply
```

## Run the ansible scripts

```bash
./ansible-Ping.sh # to check if the instances are reachable
./ansiblePlay.sh # to run the playbook
```

## to run all

```bash
./create.sh
```

## to destroy all

```bash
./destroy.sh
```