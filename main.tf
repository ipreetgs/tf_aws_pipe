provider "aws" {
  region = "us-east-1"
}
# S3 Bucket resource
resource "aws_s3_bucket" "example_bucket" {
  bucket = "demotxchd"
  acl    = "private"
}