# Resource Block
resource "aws_s3_bucket" "bucket" {
  bucket = "my-bucket"
  acl    = "private"

  tags = {
    "Name": "MyBucket"
  }
}

# Resource Block

resource "random_pet" "petname" {
  length = 5
  separator = "-"
}