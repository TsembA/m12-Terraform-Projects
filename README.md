# ☁️ Terraform AWS EC2 Infrastructure with VPC, Subnet, and SSH Provisioning

This Terraform project provisions a **complete EC2 setup** inside a custom **VPC** with internet access, SSH key pair, and file/script provisioning.

---

## 🌍 Region

Resources are deployed in:

```
us-west-1 (N. California)
```

---

## 🧱 Infrastructure Components

### 🔹 1. VPC
Creates a custom Virtual Private Cloud.

```hcl
resource "aws_vpc" "myapp_vpc"
```

- Uses CIDR from `var.vpc_cidr_block`
- Tagged with environment prefix

---

### 🔹 2. Subnet

```hcl
resource "aws_subnet" "myapp_subnet"
```

- Created in the specified Availability Zone
- CIDR from `var.subnet_cidr_block`

---

### 🔹 3. Internet Gateway and Routing

```hcl
resource "aws_internet_gateway" "myapp_igw"
resource "aws_default_route_table" "main_rtb"
```

- Enables outbound internet traffic
- Adds default route `0.0.0.0/0`

---

### 🔹 4. Security Group

```hcl
resource "aws_default_security_group" "myapp_sg"
```

- Allows SSH from your IP (`var.my_ip`)
- Opens port 8080 to the public
- Allows all outbound traffic

---

### 🔹 5. SSH Key Pair

```hcl
resource "aws_key_pair" "ssh-key"
```

- Reads public key from `var.public_key_location`
- Used by EC2 instance for SSH access

---

### 🔹 6. EC2 Instance

```hcl
resource "aws_instance" "myapp_server"
```

- AMI: Amazon Linux 2 with PyTorch 2.3.1 (fetched dynamically)
- Subnet & Security Group assignment
- Public IP association
- SSH Key authentication
- Script provisioning via:
  - `file` (uploads `entry-script.sh`)
  - `remote-exec` (executes script remotely)
  - `local-exec` (writes public IP to file)

---

### 📤 Outputs

```hcl
output "aws_ami_id"
output "ec2_public_ip"
```

---

## 📌 Required Variables

| Name                  | Description                              |
|-----------------------|------------------------------------------|
| `vpc_cidr_block`      | CIDR block for the VPC                   |
| `subnet_cidr_block`   | CIDR block for the subnet                |
| `avail_zone`          | Availability zone (e.g., us-west-1a)    |
| `env_prefix`          | Prefix for naming/tagging resources      |
| `my_ip`               | Your public IP in CIDR format (e.g. x.x.x.x/32) |
| `instance_type`       | EC2 instance type (e.g., t2.micro)       |
| `public_key_location` | Path to SSH public key file              |
| `private_key_location`| Path to SSH private key file             |

---

## 🚀 Usage

```bash
terraform init
terraform plan
terraform apply
```

Ensure you have your `entry-script.sh`, public key, and private key ready.

---

## 📁 File Structure

```
.
├── main.tf
├── variables.tf
├── entry-script.sh
├── terraform.tfvars
├── README.md
```

---

