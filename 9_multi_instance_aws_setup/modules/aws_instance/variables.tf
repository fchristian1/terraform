variable "instance_ami" {
  description = "AMI to use for the instance"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

variable "instance_name" {
  description = "Name of the instance"
  type        = string
  default     = "MyInstance"
}

variable "instance_type" {
  description = "Type of the instance"
  type        = string
  default     = "t2.micro"
}

variable "region" {
  description = "Region to deploy the instance"
  type        = string
  default     = "eu-central-1"
}
variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}
variable "key_name" {
  type = string
}
