
# 🚀 AWS Infrastructure with Terraform

This project provisions a complete AWS environment using **Terraform**, including networking, security groups, and an EC2 instance configured with a specific AMI. It’s modular, parameterized, and ideal for deploying consistent infrastructure across environments.

---

## ⚙️ What It Does

- Creates a **Virtual Private Cloud (VPC)**.
- Adds a **Subnet** within a specified Availability Zone.
- Attaches an **Internet Gateway** for outbound traffic.
- Configures a **Route Table** and associates it with the subnet.
- Sets up a **Security Group** with SSH and HTTP access.
- **Fetches the latest Amazon Linux 2 AMI** with GPU support.
- Launches an **EC2 Instance** using the selected AMI.
- Sets up **SSH access** using a provided public key.
- Executes a **startup script** on the EC2 instance (`entry-script.sh`).

---

## 📦 Resources

| Resource                       | Description                                      |
|--------------------------------|--------------------------------------------------|
| `aws_vpc`                      | Defines the VPC                                  |
| `aws_subnet`                   | Subnet in the VPC                                |
| `aws_internet_gateway`         | Enables internet connectivity                    |
| `aws_default_route_table`      | Routes internet traffic                          |
| `aws_default_security_group`   | Configures access rules                          |
| `aws_ami` (data source)        | Selects the most recent compatible AMI           |
| `aws_key_pair`                 | Loads public key for SSH                         |
| `aws_instance`                 | Launches the EC2 instance                        |

---

## 🧾 Input Variables

| Variable               | Description                                |
|------------------------|--------------------------------------------|
| `vpc_cidr_block`       | CIDR block for the VPC                     |
| `subnet_cidr_block`    | CIDR block for the subnet                  |
| `avail_zone`           | Availability zone for subnet              |
| `env_prefix`           | Prefix for naming AWS resources           |
| `my_ip`                | Your public IP for SSH access             |
| `instance_type`        | EC2 instance type (e.g. t2.micro)         |
| `public_key_location`  | Path to your SSH public key file          |

---

## 📤 Outputs

| Output Name        | Description                          |
|--------------------|--------------------------------------|
| `aws_ami_id`       | ID of the Amazon Linux AMI used      |
| `ec2_public_ip`    | Public IP of the EC2 instance        |
| `ec2_instance_id`  | EC2 instance ID                      |

---

## 🔐 Security

- SSH allowed only from your IP (port 22).
- Public HTTP access via port 8080.
- All outbound traffic allowed by default.

---

## 📝 User Data Script

`entry-script.sh` is executed upon instance launch, enabling software installation or environment configuration.

---

## ✅ Best Practices

- Use `terraform.tfvars` to set variable values.
- Always initialize with `terraform init`.
- Preview changes with `terraform plan`.
- Apply with `terraform apply`.

---

## 🧠 Note

This project avoids using provisioners to prevent unexpected behaviors. Initialization is handled via `user_data`. For post-deployment configuration, consider using Ansible or similar tools.

