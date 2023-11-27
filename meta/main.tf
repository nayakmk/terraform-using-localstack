# Create VPC
# Create Subnet
# Create Internet Gateway
# Create Route Table
# Create Route in Route Table for Internet Access
# Associate Route Table with Subnet
# Create Security Group in the VPC with port 80, 22 as inbound open
# Create EC2 Instance in respective new vpc, new subnet created above with a static key pair, associate Security group created earlier
# Create Elastic IP Address and Associate to EC2 Instance
# Use depends_on Resource Meta-Argument attribute when creating Elastic IP

# Resource Block - VPC
resource "aws_vpc" "vpc-dev" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "name" : "VPC Dev"
  }
}

# Resource Block - Subnet
resource "aws_subnet" "subnet-dev" {
  vpc_id            = aws_vpc.vpc-dev.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    "name" : "Subnet Dev"
  }
}

# Resource Block - Internet Gateway
resource "aws_internet_gateway" "gateway-dev" {
  vpc_id = aws_vpc.vpc-dev.id

  tags = {
    "name" : "Gateway Dev"
  }
}

# Resource Block - Route Table
resource "aws_route_table" "rt-dev" {
  vpc_id = aws_vpc.vpc-dev.id
}

# Resource Block - Route
resource "aws_route" "vpc-dev-public-route" {
  route_table_id         = aws_route_table.rt-dev.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway-dev.id
}

# Resource Block - Route Table Subnet Association
resource "aws_route_table_association" "vpc-dev-public-route-table-association" {
  route_table_id = aws_route_table.rt-dev.id
  subnet_id      = aws_subnet.subnet-dev.id
}

# Resource Block - Security Group
resource "aws_security_group" "dev-vpc-sg2" {
  vpc_id      = aws_vpc.vpc-dev.id
  description = "Dev VPC Security Group"

  ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all ip and ports outboun"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


# Resource Block
resource "aws_instance" "my-ec2" {
  ami                    = "ami-ff0fea8310f3"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  subnet_id              = aws_subnet.subnet-dev.id
  vpc_security_group_ids = [aws_security_group.dev-vpc-sg2.id]

  tags = {
    "name" : "localstack-ec2"
    "value" : "my-ec2"
  }
}
