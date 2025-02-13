provider "aws" {
  region = "eu-central-1"
}

resource "random_integer" "random" {
  min = 10000
  max = 99999
  keepers = {
    always_same = "static_value"
  }
}

# resources to save the state file in S3 and DynamoDB
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-${random_integer.random.result}"

}

resource "aws_dynamodb_table" "terraform_locks" {
  name           = "terraform-locks"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
