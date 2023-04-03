provider "aws" {
  region = "us-east-1"
}
# S3 Bucket resource
resource "aws_s3_bucket" "example_bucket" {
  bucket = "demotxchd"
  acl    = "private"
}

# EC2 Instance resource
resource "aws_instance" "web" {
  ami           = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
  key_name      = "tf"
  security_groups = sg-06138044ec110f4ba
  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = 10
  }
}
