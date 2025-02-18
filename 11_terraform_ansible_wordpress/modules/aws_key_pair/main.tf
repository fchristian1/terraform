
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "my_key_file" {
  file_permission = 0600
  content         = tls_private_key.my_key.private_key_pem
  filename        = var.key_path
}

resource "aws_key_pair" "my_aws_key" {
  key_name   = var.key_name
  public_key = tls_private_key.my_key.public_key_openssh

}

variable "key_path" {
  type = string
}

variable "key_name" {
  type = string
}

output "name" {
  value = aws_key_pair.my_aws_key.key_name
}
