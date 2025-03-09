# resource "aws_instance" "myec2" {
#   ami = "ami-05b10e08d247fb927"
#   instance_type = "t2.micro"
#   count = 3

#   tags = {
#     Name = "payments-system-${count.index}"
#   }
  
# }

# resource "aws_iam_user" "this" {
#   name = "payments-user-${count.index}"
#   count = 3
# }

variable "users" {
  type = list
  default = ["user1", "user2", "user3"]
}

resource "aws_iam_user" "example" {
  name = var.users[count.index]
  count = 3
}
