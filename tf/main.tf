terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.1"
}

provider "aws" {
  region = var.aws_region
}

# Use latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Upload your public key to AWS
resource "aws_key_pair" "deployer" {
  key_name   = "local-deployer-key-${substr(md5(file(var.public_key_path)), 0, 6)}"
  public_key = file(var.public_key_path)
}

# Default VPC & subnet
data "aws_vpc" "default" {
  default = true
}
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
# Security group to allow SSH & Jenkins port
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg-${substr(md5(timestamp()),0,6)}"
  description = "Allow SSH and Jenkins HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port   = var.jenkins_port
    to_port     = var.jenkins_port
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

# EC2 instance
resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  subnet_id              = data.aws_subnets.default.ids[0]
  associate_public_ip_address = true

  tags = {
    Name = "jenkins-from-local"
  }

  user_data = <<-EOF
              #cloud-config
              package_update: true
              runcmd:
                - [ sh, -c, "echo 'Instance ready' > /tmp/provision" ]
              EOF
}
