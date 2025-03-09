provider "aws" {
  region = "us-east-1"
}
resource "aws_security_group" "terraform-firewall" {
  name        = "terraform-firewall"
  description = "Managed from Terraform "

}

resource "aws_vpc_security_group_ingress_rule" "terraform-firewall" {
  security_group_id = aws_security_group.terraform-firewall.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "terraform-firewall" {
  security_group_id = aws_security_group.terraform-firewall.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# resource "aws_security_group_rule" "ingress_http" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 100
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"] # Consider restricting this to a specific range
#   security_group_id = aws_security_group.terraform-firewall.id
# }

# resource "aws_security_group_rule" "egress_all" {
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.terraform-firewall.id
# }