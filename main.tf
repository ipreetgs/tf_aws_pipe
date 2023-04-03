# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# S3 Bucket resource
resource "aws_s3_bucket" "example_bucket" {
  bucket = "demotxchd"
  acl    = "private"
}
# SEcurity group
resource "aws_security_group" "example_security_group" {
  name_prefix = "example"
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance resource
resource "aws_instance" "web" {
  ami           = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
  key_name      = "tf"
  security_groups = [aws_security_group.example_security_group.id]
  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = 100
  }
}
