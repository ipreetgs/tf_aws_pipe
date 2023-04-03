# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# S3 Bucket resource
resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket"
  acl    = "private"
}

# EC2 Instance resource
resource "aws_instance" "example_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "tf"

  # Attach the instance to a security group that allows SSH access
  security_groups = ["ssh-access"]

  # Provision the instance with a script
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup python -m SimpleHTTPServer 80 &
              EOF

  # Attach an EBS volume to the instance
  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = 100
  }
}
