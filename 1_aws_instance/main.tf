
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "my_key_file" {
  file_permission = 0600
  content         = tls_private_key.my_key.private_key_pem
  filename        = "${path.module}/my_key.pem"
}

provider "aws" {
  region = "eu-central-1" # Ändere die Region nach Bedarf
}

resource "aws_key_pair" "my_aws_key" {
  key_name   = "my_aws_key"
  public_key = tls_private_key.my_key.public_key_openssh

}

resource "aws_security_group" "my_sg" {
  name        = "my_sg"
  description = "Allow HTTP and SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "example" {
  ami = "ami-07eef52105e8a2059" # Amazon Linux 2 AMI für eu-central-1

  instance_type   = "t2.micro"
  key_name        = aws_key_pair.my_aws_key.key_name
  security_groups = [aws_security_group.my_sg.name]

  tags = {
    Name = "Terraform-Example"
  }
}
output "ec2_public_ip" {
  value = aws_instance.example.public_ip
}
output "ssh_command" {
  value = "ssh -i my_key.pem ubuntu@${aws_instance.example.public_ip}"
}
