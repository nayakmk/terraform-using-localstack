# Create EC2 Instance
resource "aws_instance" "my-ec2" {
  ami               = "ami-0915bcb5fa77e4892" # Amazon Linux
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  # availability_zone = "us-east-1b"
  tags = {
    "Name" = "web-1"
  }
 
  lifecycle {
    create_before_destroy = true
  }

}

# Create EC2 Instance
resource "aws_instance" "web-2" {
  ami = "ami-0915bcb5fa77e4892" # Amazon Linux
  instance_type = "t2.micro"
  tags = {
    "Name" = "web-2"
  }
  # lifecycle {
  #   prevent_destroy = true # Default is false
  # }
}

# Create EC2 Instance
resource "aws_instance" "web-3" {
  ami = "ami-0915bcb5fa77e4892" # Amazon Linux
  instance_type = "t2.micro"
  tags = {
    "Name" = "web-4"
  }

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }
}