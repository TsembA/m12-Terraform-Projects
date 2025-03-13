provider "aws" {
  region = "us-west-1"
}

# Create VPC
resource "aws_vpc" "myapp_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

#--------------------------------------------
module "myapp-subnet" {
  source                 = "./modules/subnet"
  vpc_cidr_block         = var.vpc_cidr_block
  subnet_cidr_block      = var.subnet_cidr_block
  avail_zone             = var.avail_zone
  vpc_id                 = aws_vpc.myapp_vpc.id
  env_prefix             = var.env_prefix
  default_route_table_id = aws_vpc.myapp_vpc.default_route_table_id
}

module "myapp-webserver" {
  source              = "./modules/webserver"
  vpc_id              = aws_vpc.myapp_vpc.id  # Fixed typo
  my_ip               = var.my_ip
  env_prefix          = var.env_prefix
  image_name          = var.image_name
  public_key_location = var.public_key_location
  instance_type       = var.instance_type
  subnet_id           = module.myapp-subnet.subnet.id # Use the output from myapp-subnet module
  avail_zone          = var.avail_zone
}
#--------------------------------------------