resource "aws_s3_bucket" "bucket" {
  bucket = "my-bucket"
  acl    = "private"
}