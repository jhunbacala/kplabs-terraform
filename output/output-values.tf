resource "aws_eip" "ld" {
  domain = "vpc"
}

/*
output "public-ip" {
  value = aws_eip.ld.public_ip
}
*/


output "public-ip" {
  value = "https://${aws_eip.ld.public_ip}:8080"
  
}