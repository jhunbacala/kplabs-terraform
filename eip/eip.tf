provider "aws" {
  region = "us-east-1"
}

resource "aws_eip" "my-lb" {
  domain = "vpc"
}

resource "aws_security_group" "example" {
    name        = "attribute-sg"
}

resource "aws_vpc_security_group_ingress_rule" "example" {
    security_group_id = aws_security_group.example.id
    cidr_ipv4         = "${aws_eip.my-lb.public_ip}/32"
    from_port         = 443
    ip_protocol       = "tcp"
    to_port           = 443
}