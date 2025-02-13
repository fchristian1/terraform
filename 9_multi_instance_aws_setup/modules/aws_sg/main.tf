terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
resource "aws_security_group" "sg" {
  for_each    = var.sg_rules
  name        = each.key
  description = "Security Group for EC2"

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}

output "sg_ids" {
  value = { for k, sg in aws_security_group.sg : k => sg.id }
}
