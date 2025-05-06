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
##Using Terraform provisioners (like file, remote-exec, and local-exec) is generally considered bad practice in production for several key reasons:

❌ 1. Provisioners Break Declarative Paradigm
Terraform is designed to manage infrastructure as declarative code — describing what the end state should be. Provisioners introduce imperative logic — commands that say how to get there, which breaks that model.

❌ 2. Unpredictable Behavior
Provisioners often depend on:

SSH connectivity
Network stability
Correct credentials
If something fails (e.g., network blip, host not yet ready), Terraform can’t always recover gracefully. It may:

Hang
Fail
Partially provision resources
❌ 3. Difficult Error Handling and Debugging
Errors from provisioners are not always clear or retryable. Terraform lacks the robust retry/error-handling logic of dedicated config tools like Ansible, Chef, or cloud-init.

❌ 4. Lifecycle Complexity
Provisioners run only on resource creation, not on updates. If you change a script or its source file:

Terraform won’t re-run it unless the entire resource is destroyed and recreated.
This leads to hidden state drift and brittle workflows.
❌ 5. Security Risks
Using private keys directly in Terraform code (as in connection { private_key = file(...) }) exposes sensitive credentials, especially if versioned or shared.
