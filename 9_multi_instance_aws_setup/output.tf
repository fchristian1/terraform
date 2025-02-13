output "ansible_ssh_command" {
  value = [for instance in module.aws-instances : instance.ansible_ssh_command]
}
