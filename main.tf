# EC2 Instance
resource "aws_instance" "example" {
  ami           = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
  tags = {
    Name = "example"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "example" {
  bucket = "bucketthirdinnovation9875656"
  acl    = "private"

  tags = {
    Name = "example"
  }
}

# VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "example"
  }
}

# Security Group
resource "aws_security_group" "example" {
  name_prefix = "example-sg"
  vpc_id      = aws_vpc.example.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example"
  }
}
