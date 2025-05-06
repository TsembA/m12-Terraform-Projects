# 🌐 Terraform AWS VPC and Web Server Project

This project uses **Terraform** to provision a custom **VPC**, a **subnet**, and an **EC2 web server** on AWS. 
The setup is **modular** , promoting reusability and easy maintenance across different environments (e.g., development, staging, production).

---

## 📍 Region

All resources are deployed in:

```
us-west-1 (N. California)
```

---

## 📦 Project Structure

This project uses local modules for better separation of concerns:

- `./modules/subnet` – Manages subnet creation
- `./modules/webserver` – Manages EC2 instance and related settings

---

## ⚙️ Provider Configuration

```hcl
provider "aws" {
  region = "us-west-1"
}
```

---

## 🏗️ VPC Creation

```hcl
resource "aws_vpc" "myapp_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}
```

Creates a custom VPC using a CIDR block defined in `variables.tf`. The VPC is tagged with a dynamic name.

---

## 🌐 Subnet Module

```hcl
module "myapp-subnet" {
  source                 = "./modules/subnet"
  vpc_cidr_block         = var.vpc_cidr_block
  subnet_cidr_block      = var.subnet_cidr_block
  avail_zone             = var.avail_zone
  vpc_id                 = aws_vpc.myapp_vpc.id
  env_prefix             = var.env_prefix
  default_route_table_id = aws_vpc.myapp_vpc.default_route_table_id
}
```

This module provisions a subnet in the defined VPC and availability zone. It receives the route table ID and tags from the parent module.

---

## 🖥️ Web Server Module

```hcl
module "myapp-webserver" {
  source              = "./modules/webserver"
  vpc_id              = aws_vpc.myapp_vpc.id
  my_ip               = var.my_ip
  env_prefix          = var.env_prefix
  image_name          = var.image_name
  public_key_location = var.public_key_location
  instance_type       = var.instance_type
  subnet_id           = module.myapp-subnet.subnet.id
  avail_zone          = var.avail_zone
}
```

This module provisions a web server (EC2 instance) with:

- AMI (`image_name`)
- SSH access (`public_key_location`)
- IP whitelisting (`my_ip`)
- Custom instance type (e.g., `t2.micro`)

---

## 🏷️ Tags

All resources are tagged with a prefix like `dev`, `prod`, etc. to distinguish environments.

---

## 🚀 Usage

```bash
terraform init
terraform plan
terraform apply
```

---

## 📁 File Structure

```
.
├── main.tf
├── variables.tf
├── outputs.tf
├── modules/
│   ├── subnet/
│   └── webserver/
└── README.md
```


