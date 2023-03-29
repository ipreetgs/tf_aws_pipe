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
# Create an S3 bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = var.bucket_name
}

# Create a VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "example-vpc"
  }
}

# Create a subnet
resource "aws_subnet" "example_subnet" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name = "example-subnet"
  }
}

# Create an EC2 instance
resource "aws_instance" "example_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.example_subnet.id
  key_name      = var.key_name

  tags = {
    Name = "example-instance"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello, world!' > /tmp/hello.txt",
    ]
  }
}

# Create an Elastic Container Registry (ECR) repository
resource "aws_ecr_repository" "example_repository" {
  name = var.ecr_repository_name
}

# Create a CodeBuild project
resource "aws_codebuild_project" "example_build_project" {
  name          = "example-build-project"
  description   = "Example build project"
  build_timeout = 60

  source {
    type            = "CODEPIPELINE"
    buildspec       = "buildspec.yml"
    git_clone_depth = 1
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    type            = "LINUX_CONTAINER"
    image           = "aws/codebuild/standard:4.0"
    privileged_mode = true
  }

  service_role = aws_iam_role.example_build_role.arn
}

# Create an IAM role for the CodeBuild project
resource "aws_iam_role" "example_build_role" {
  name = "example-build-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  # Attach policies that grant the necessary permissions for your build project
}

# Create a CodePipeline that deploys the EC2 instance and builds and pushes a Docker image to ECR
resource "aws_codepipeline" "example_pipeline" {
  name     = "example-pipeline"
  role_arn = aws_iam_role.example_pipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.example_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name            = "Source"
      category        = "Source"
      owner           = "AWS"
      provider        = "S3"
      version         = "1"
      output_artifacts = ["source_output"]

      configuration = {
        BucketName = aws_s3_bucket.example_bucket.bucket
        Key        = "source.zip"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "Code

