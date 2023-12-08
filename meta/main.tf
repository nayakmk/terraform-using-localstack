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
    Name : "VPC Dev"
  }
}

# Resource Block - Subnet
resource "aws_subnet" "public-subnet-dev" {
  vpc_id                  = aws_vpc.vpc-dev.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name : "Subnet Dev"
  }
}

# Resource Block - Internet Gateway
resource "aws_internet_gateway" "gateway-dev" {
  vpc_id = aws_vpc.vpc-dev.id

  tags = {
    Name : "Gateway Dev"
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

/*
The aws_route_table_association resource associates the route table rt-dev with the subnet public-subnet-dev. 
This means that traffic originating from the subnet public-subnet-dev will be routed according to the rules defined in the route table rt-dev.
*/
resource "aws_route_table_association" "vpc-dev-public-route-table-association" {
  route_table_id = aws_route_table.rt-dev.id
  subnet_id      = aws_subnet.public-subnet-dev.id
}

# Resource Block - Security Group

/*
The aws_security_group resource creates a security group named dev-vpc-sg2 for the VPC vpc-dev. 
It allows inbound traffic on ports 22 (SSH) and 80 (HTTP) from anywhere, and allows all outbound traffic.
*/
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
  key_name               = "terraform-key"
  subnet_id              = aws_subnet.public-subnet-dev.id
  vpc_security_group_ids = [aws_security_group.dev-vpc-sg2.id]

  # Meta Argument
  count = 5

  tags = {
    Name = "my-ec2-instance-${count.index}"
  }
}

# Resource Block - Elastic IP
resource "aws_eip" "dev-eip" {
  # Meta Argument - count
  count = 5

  instance = aws_instance.my-ec2[count.index].id

  # Meta Argument - depends_on
  depends_on = [aws_internet_gateway.gateway-dev]
}

# Create S3 Bucket per environment with for_each and maps
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket

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