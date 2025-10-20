# AWS region
variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

# EC2 instance type
variable "instance_type" {
  type    = string
  default = "t3.micro"
}

# Path to your SSH public key (from my laptop)
variable "public_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

# Linux user for SSH
variable "ssh_user" {
  type    = string
  default = "ubuntu"
}

# Jenkins port
variable "jenkins_port" {
  type    = number
  default = 8080
}
