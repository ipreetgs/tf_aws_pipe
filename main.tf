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
locals {
  bucketName = var.BucketName
}

provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/credentials"
  profile = "demo"
}

resource "aws_s3_bucket" "bucket" {
  bucket = local.bucketName

  versioning {
    enabled = true
  }

  acl = "private"

  tags = {
    Name        = "My bucket"
    Environment = "test"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    id = "demorule"

    filter {}

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    status = "Enabled"
  }
}

resource "aws_security_group" "instance" {
  name_prefix = "instance"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "mykey"
  subnet_id     = "subnet-12345678"
  
  vpc_security_group_ids = [aws_security_group.instance.id]
  
  tags = {
    Name = "My EC2 Instance"
  }
}


