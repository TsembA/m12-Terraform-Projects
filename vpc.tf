provider "aws" {
  region = "us-west-1"
}

variable "vpc_cidr_block" {}
variable "private_subnet_cidr_blocks" {}
variable "public_subnet_cidr_blocks" {}

# Fetch all available AZs in the region
data "aws_availability_zones" "available" {}

output "azs" {
  value = data.aws_availability_zones.available.names
}

module "myapp-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name            = "myapp-vpc"
  cidr            = var.vpc_cidr_block
  public_subnets  = var.public_subnet_cidr_blocks
  private_subnets = var.private_subnet_cidr_blocks

  # ✅ Corrected AZs reference
  azs = data.aws_availability_zones.available.names

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"        = 1
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/elb"                 = 1
  }
}
