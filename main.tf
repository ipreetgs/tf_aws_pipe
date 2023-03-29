# locals {
#   bucketName=var.BucketName
# }
# provider "aws" {
#   region = "us-east-1"
#   shared_credentials_files = ["/credentials"]
#   profile = "demo"
# }

# resource "aws_s3_bucket" "bucket" {
#   bucket = local.bucketName
#   versioning {
#     enabled=true
#   }
  
#   acl = "private"
#   tags = {
#     Name        = "My bucket"
#     Environment = "test"
#   }
# }
# resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
#   bucket=aws_s3_bucket.bucket.bucket
#   rule {
#     id = "demorule"

#     filter {}

#     transition {
#       days          = 30
#       storage_class = "STANDARD_IA"
#     }

#     transition {
#       days          = 60
#       storage_class = "GLACIER"
#     }

#     status = "Enabled"
#   }
    
# }


# Configure AWS provider
provider "aws" {
  region = "us-east-1"
}

# Create S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-bucket"
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "My VPC"
  }
}

# Create subnet
resource "aws_subnet" "my_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1"
  tags = {
    Name = "My Subnet"
  }
}

# Create security group
resource "aws_security_group" "my_security_group" {
  name = "My Security Group"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 instance
resource "aws_instance" "my_instance" {
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  tags = {
    Name = "My Instance"
  }
}

# Create RDS instance
resource "aws_db_instance" "my_db_instance" {
  allocated_storage = 10
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  name = "my-db-instance"
  username = "admin"
  password = "password123"
  subnet_group_name = "my-subnet-group"
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
}
