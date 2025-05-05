variable "password" {
  default = "supersecretpassw0rd"
  sensitive = true
}

resource "local_sensitive_file" "foo" {
#   content  = var.password
  content  = "supersecretpassw0rd"
  filename = "password.txt"
}

# output "pass" {
#   value = local_sensitive_file.foo.content
# }

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}