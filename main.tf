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






provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "example" {
  bucket = "example-bucket"
  acl    = "private"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "example-vpc"
  }
}

resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "example-subnet"
  }
}

resource "aws_security_group" "example" {
  name_prefix = "example"
  vpc_id      = aws_vpc.example.id

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
  key_name      = "example-key"
  subnet_id     = aws_subnet.example.id
  vpc_security_group_ids = [aws_security_group.example.id]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/example-key.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo service nginx start"
    ]
  }
}

resource "aws_db_subnet_group" "example" {
  name       = "example-db-subnet-group"
  subnet_ids = [aws_subnet.example.id]

  tags = {
    Name = "example-db-subnet-group"
  }
}

resource "aws_db_instance" "example" {
  engine               = "mysql"
  engine_version       = "8.0.23"
  instance_class       = "db.t2.micro"
  allocated_storage    = 20
  name                 = "example-db"
  username             = "example-user"
  password             = "example-password"
  db_subnet_group_name = aws_db_subnet_group.example.name

  tags = {
    Name = "example-db"
  }
}

