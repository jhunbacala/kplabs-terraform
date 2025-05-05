resource "aws_instance" "sample-ec2" {
  ami = "ami-0e449927258d45bc4"
  instance_type = "t2.micro"
  depends_on = [ aws_s3_bucket.fb-sample-bucket ]
}

resource "aws_s3_bucket" "fb-sample-bucket" {
  bucket = "fb-sample-bucket-001"
}

