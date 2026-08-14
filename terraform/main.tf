terraform {
  backend "s3" {
    bucket         = "my-terraform-state-ansy"   # Name of your S3 bucket
    key            = "devops/terraform.tfstate"  # Path inside the bucket
    region         = "us-east-1"            # Region where the bucket exists
    use_lockfile = "true"                   # Lockfile  for state locking
    encrypt        = true                   # Encrypt state at rest
  }
}

provider "aws" {
  region = var.aws_region
}

# Reference the default VPC instead of recreating it
data "aws_vpc" "default" {
  default = true
}

# Get all subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group allowing SSH + app ports
resource "aws_security_group" "devops_sg" {
  vpc_id = data.aws_vpc.default.id
  name   = "devops-sg-01"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-sg"
  }
}

# Fetch a fixed Ubuntu AMI (pin version to avoid recreation)
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical's official AWS account ID
}

# EC2 Instance
resource "aws_instance" "devops_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = data.aws_subnets.default.ids[0]

  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  tags = {
    Name = "devops-instance"
  }
}
