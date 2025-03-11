# Configure the AWS Provider
provider "aws" {
  region = "us-east-1" # Change to your preferred region
}

# Data source to get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
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

# Create EC2 instances using count
resource "aws_instance" "instances" {
  count         = 2
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  
  tags = {
    Name = "hostname_${count.index + 1}" # Creates hostname1 and hostname2
  }
}

# Optional: Output the instance IDs and public IPs
output "instance_ids" {
  value = aws_instance.instances[*].id
}

output "public_ips" {
  value = aws_instance.instances[*].public_ip
}