# main.tf

# Provider configuration
provider "aws" {
  region = "us-east-1"  # You can change this to your preferred region
}

# Data source to fetch the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]  # Pattern for Amazon Linux 2023 AMIs
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Create a security group to allow SSH access
resource "aws_security_group" "instance_sg" {
  name        = "terraform-example-sg"
  description = "Allow SSH inbound traffic"

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

# EC2 instance resource using the latest AMI
resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux_2023.id  # Use the dynamically fetched AMI ID
  instance_type = "t2.micro"
  
  # Security group association
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  
  # User data script to install AWS CLI and Terraform
  user_data = <<-EOF
              #!/bin/bash
              # Update package repository
              yum update -y
              
              # Install AWS CLI
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              ./aws/install
              rm -rf awscliv2.zip aws
              
              # Install Terraform
              yum install -y yum-utils
              yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/terraform.repo
              yum install -y terraform
              
              # Verify installations
              aws --version
              terraform version
              EOF

  tags = {
    Name = "terraform-aws-host"
  }
}

# Output the public IP of the instance
output "instance_public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP address of the EC2 instance"
}

# Output the AMI ID used
output "used_ami_id" {
  value       = data.aws_ami.amazon_linux_2023.id
  description = "The AMI ID used for the instance"
}