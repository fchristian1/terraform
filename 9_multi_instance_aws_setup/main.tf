provider "aws" {
  region = "eu-central-1"
}


module "key_pair" {
  source   = "./modules/aws_key_pair"
  key_path = "./my_key.pem"
  key_name = "my_aws_key"
}
module "sg" {
  source = "./modules/aws_sg"
  sg_rules = {
    "ssh" = {
      ingress = [
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    },
    "http" = {
      ingress = [
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    },
    https = {
      ingress = [{
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }]
    }
  }
}

module "aws-instances" {
  source             = "./modules/aws_instance"
  instance_name      = "server-${count.index}"
  count              = 3
  key_name           = module.key_pair.name
  security_group_ids = values(module.sg.sg_ids)
  providers = {
    aws = aws
  }
  depends_on = [module.key_pair, module.sg]
}

