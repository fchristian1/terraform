terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_instance" "instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name
  tags = {
    Name = var.instance_name
  }
  vpc_security_group_ids = var.security_group_ids
}
output "debug_sg_ids" {
  value = var.security_group_ids
}
