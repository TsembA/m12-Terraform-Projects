provider "aws" {
  region = "us-west-1"
}

# Define input variables
variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "my_ip" {}
variable "instance_type" {}
variable "public_key_location" {}


# Create VPC
resource "aws_vpc" "myapp_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

# Create Subnet
resource "aws_subnet" "myapp_subnet" {
  vpc_id            = aws_vpc.myapp_vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone

  tags = {
    Name = "${var.env_prefix}-subnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "myapp_igw" {
  vpc_id = aws_vpc.myapp_vpc.id

  tags = {
    Name = "${var.env_prefix}-igw"
  }
}

# Associate subnet with default Route Table
resource "aws_default_route_table" "main_rtb" {
  default_route_table_id = aws_vpc.myapp_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp_igw.id
  }

  tags = {
    Name = "${var.env_prefix}-main-rtb"
  }
}

# Create Security Group
resource "aws_default_security_group" "myapp_sg" {
  vpc_id = aws_vpc.myapp_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-default-sg"
  }
}

# Fetch Latest Amazon Linux 2 AMI
data "aws_ami" "lts_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Deep Learning OSS Nvidia Driver AMI GPU PyTorch 2.3.1 (Amazon Linux 2) 20250223"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "aws_ami_id" {
  value = data.aws_ami.lts_amazon_linux.id
}

output "ec2_public_ip" {
  value = aws_instance.myapp_server.public_ip
}

output "ec2_instance_id" {
  value = aws_instance.myapp_server.id
}


resource "aws_key_pair" "ssh-key" {
  key_name = "new-server-key"
  public_key = file(var.public_key_location)
  
}

# Create EC2 Instance
resource "aws_instance" "myapp_server" {
  ami                    = data.aws_ami.lts_amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.myapp_subnet.id
  vpc_security_group_ids = [aws_default_security_group.myapp_sg.id]
  availability_zone      = var.avail_zone
  associate_public_ip_address = true
  key_name               = aws_key_pair.ssh-key.key_name


  user_data = file("entry-script.sh")

  user_data_replace_on_change = true

  tags = {
    Name = "${var.env_prefix}-server"
  }
}
