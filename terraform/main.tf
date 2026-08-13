provider "aws" {
  region = var.aws_region
}
// Use the account's default VPC and an available subnet instead of creating a new VPC.
data "aws_default_vpc" "default" {}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_default_vpc.default.id
}

# Security Group allowing SSH
resource "aws_security_group" "devops_sg" {
  vpc_id = data.aws_default_vpc.default.id
  name   = "devops-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For testing; restrict to your IP in production
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

# Fetch latest Ubuntu 24.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# EC2 Instance (launched into the default VPC's first subnet)
resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = element(data.aws_subnet_ids.default.ids, 0)
  vpc_security_group_ids = [aws_security_group.devops_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "AppServer"
  }
}
