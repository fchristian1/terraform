terraform {
  backend "s3" {
    bucket         = "terraform-state-83e7283f-9fb1-4276-84c0-6afa415dd137"
    dynamodb_table = "terraform-locks-83e7283f-9fb1-4276-84c0-6afa415dd137"
    region         = "eu-central-1"
    encrypt        = true
    key            = "projektname-terraform.tfstate"
  }
}
