# provider "aws" {
#   region = "us-east-1"
# }

# resource "aws_instance" "myecs2" {
#   ami = "ami-08b5b3a93ed654d19"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "Linux-Instance-1"
#   }
# }

provider "aws" {
  region = "us-east-1"
}

# Security Group for SSH Access
resource "aws_security_group" "allow_ssh" {
  name_prefix = "allow_ssh"
  description = "Allow SSH access for EC2 Instance Connect"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to all (restrict for security)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# IAM Role for EC2 Instance Connect
resource "aws_iam_role" "ec2_instance_connect" {
  name = "EC2InstanceConnectRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Attach EC2 Instance Connect IAM Policy
resource "aws_iam_policy_attachment" "ec2_connect_attach" {
  name       = "ec2-connect-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  roles      = [aws_iam_role.ec2_instance_connect.name]
}

# Create IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_instance_connect.name
}

# Create EC2 Instance
resource "aws_instance" "myecs2" {
  ami           = "ami-08b5b3a93ed654d19"  # Amazon Linux 2023 AMI
  instance_type = "t2.micro"
  security_groups = [aws_security_group.allow_ssh.name]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "Linux-Instance-1"
  }
}
