output "ssh_command" {
  value = "ssh -i my_key.pem ubuntu@${aws_instance.instance.public_ip}"
}
output "ec2_public_ip" {
  value = aws_instance.instance.public_ip
}
# Ansible connection shell promt

output "ansible_ssh_command" {
  value = "ansible -i ${aws_instance.instance.public_ip}, -u ubuntu --private-key my_key.pem all -m ping"
}

output "ansible_addHost_command" {
  value = "ansible-inventory -i ${aws_instance.instance.public_ip}, --list"
}

output "public_ip" {
  value = aws_instance.instance.public_ip

}
