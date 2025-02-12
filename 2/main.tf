terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "1.4.0"
    }
  }
}

variable "unique_name" {
  type        = string
  description = "A unique name for the resource"
}

resource "local_file" "example" {
  filename = "${var.unique_name}.txt"
  content  = "Hello, World!"
}

provider "local" {}
