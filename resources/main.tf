# Resource Block
resource "aws_instance" "my-ec2" {
  ami               = "ami-ff0fea8310f3"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1b"

  tags = {
    "name" : "localstack-ec2"
    "value": "my-ec2"
  }
}
