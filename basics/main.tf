# Resource Block
resource "aws_s3_bucket" "bucket" {
  bucket = "my-bucket"
  acl    = "private"

  tags = {
    "Name": "MyBucket"
  }
}

resource "aws_s3_bucket" "mys3bucket" {

  # for_each Meta-Argument
  for_each = {
    dev  = "my-dapp-bucket"
    qa   = "my-qapp-bucket"
    stag = "my-sapp-bucket"
    prod = "my-papp-bucket"
  }

  bucket = "${each.key}-${each.value}"
  #acl    = "private" # This argument is deprecated, so commenting it. 


  tags = {
    Environment = each.key
    bucketname  = "${each.key}-${each.value}"
    eachvalue   = each.value
  }
}

# Resource Block

resource "random_pet" "petname" {
  length = 5
  separator = "-"
}