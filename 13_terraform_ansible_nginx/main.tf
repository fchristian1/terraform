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

module "aws-instances-controller" {
  source             = "./modules/aws_instance"
  instance_name      = "${var.projekt_name}-controller-${count.index}"
  system_type        = "controller"
  count              = 0
  key_name           = module.key_pair.name
  security_group_ids = values(module.sg.sg_ids)
  providers = {
    aws = aws
  }
  depends_on = [module.key_pair, module.sg]
}
module "aws-instances-proxy" {
  source             = "./modules/aws_instance"
  instance_name      = "${var.projekt_name}-proxy-${count.index}"
  system_type        = "proxy"
  count              = 0
  key_name           = module.key_pair.name
  security_group_ids = values(module.sg.sg_ids)
  providers = {
    aws = aws
  }
  depends_on = [module.key_pair, module.sg]
}
module "aws-instances-load-balancer" {
  source             = "./modules/aws_instance"
  instance_name      = "${var.projekt_name}-load-balancer-${count.index}"
  system_type        = "load-balancer"
  count              = 0
  key_name           = module.key_pair.name
  security_group_ids = values(module.sg.sg_ids)
  providers = {
    aws = aws
  }
  depends_on = [module.key_pair, module.sg]
}
module "aws-instances-database" {
  source             = "./modules/aws_instance"
  instance_name      = "${var.projekt_name}-database-${count.index}"
  count              = 0
  key_name           = module.key_pair.name
  security_group_ids = values(module.sg.sg_ids)
  providers = {
    aws = aws
  }
  depends_on = [module.key_pair, module.sg]
}
module "aws-instances-server" {
  source             = "./modules/aws_instance"
  instance_name      = "${var.projekt_name}-server-${count.index}"
  count              = 1
  key_name           = module.key_pair.name
  security_group_ids = values(module.sg.sg_ids)
  providers = {
    aws = aws
  }
  depends_on = [module.key_pair, module.sg]
}

## create a inventory file for ansible in ./ansible_playbook/inventory
## with module.aws-instances.public_ip output
# like this:
# [web:vars]
# ansible_ssh_user=ubuntu
# ansible_ssh_private_key_file=./../my_key.pem
# [web]
# 3.127.203.17
# 18.194.53.161
# 35.156.175.87






