output "ansible_ssh_command" {
  value = [for instance in module.aws-instances : instance.ansible_ssh_command]
}
output "public_ips" {
  value = module.aws-instances[*].public_ip
}
