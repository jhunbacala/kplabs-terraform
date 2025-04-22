resource "aws_instance" "myec2" {
   ami = "ami-00a929b66ed6e0de6"
   instance_type = var.instance_type
}