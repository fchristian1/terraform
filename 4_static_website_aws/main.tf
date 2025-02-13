# This is the main configuration file for Terraform. It contains the configuration for the AWS provider and the S3 bucket.
provider "aws" {
  region = "eu-central-1"

}
# This resource generates a random integer between 10000 and 99999. It is used to create a unique name for the S3 bucket.
resource "random_integer" "random" {
  min = 10000
  max = 99999
  keepers = {
    always_same = "static_value"
  }
}
# This is the configuration for the S3 bucket. It creates a bucket with the specified name and enables public access.
resource "aws_s3_bucket" "website" {
  bucket = "website-${random_integer.random.result}"
}

# This resource configures the public access block settings for the S3 bucket.
resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# This resource configures the bucket ownership controls for the S3 bucket.
resource "aws_s3_bucket_ownership_controls" "site" {
  bucket = aws_s3_bucket.website.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# This resource configures the bucket ACL for the S3 bucket.
resource "aws_s3_bucket_acl" "site" {
  bucket = aws_s3_bucket.website.id

  acl = "public-read"

  depends_on = [
    aws_s3_bucket_ownership_controls.site,
    aws_s3_bucket_public_access_block.site
  ]
}

# This resource configures the bucket policy for the S3 bucket.
resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          aws_s3_bucket.website.arn,
          "${aws_s3_bucket.website.arn}/*"
        ]
      },
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.site]

}

# This output block defines the output values for the Terraform configuration.
output "website_url" {
  value = "http://${aws_s3_bucket.website.website_endpoint}/"

}
# This local block defines the MIME types for the files in the website directory.
locals {
  mime_types = jsondecode(file("${path.module}/mime.json"))
}
# Upload files to the S3 bucket using the aws_s3_object resource.
resource "aws_s3_object" "source_files" {
  bucket = aws_s3_bucket.website.id

  for_each = fileset("${path.module}/website", "**/*")

  key          = each.value
  source       = "${path.module}/website/${each.value}"
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), null)

}

# Configure the S3 bucket as a static website
resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}
