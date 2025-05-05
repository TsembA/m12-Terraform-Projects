# 🚀 Terraform AWS EKS Cluster Project

This project provisions an **Amazon Elastic Kubernetes Service (EKS)** cluster using the [terraform-aws-modules/eks](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws) module. It is configured specifically for a **development environment** and includes a managed node group for running workloads.

---

## 📦 Module Summary

- **Terraform Module**: [`terraform-aws-modules/eks/aws`](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws)
- **Version**: `20.34.0`
- **Purpose**: Provision a Kubernetes cluster with a managed node group in a VPC defined in vpc.tf.

---

## ⚙️ Cluster Configuration

| Parameter                         | Value                     |
|----------------------------------|---------------------------|
| `cluster_name`                   | `myapp-eks-cluster`       |
| `cluster_version`                | `1.32`                    |
| `cluster_endpoint_public_access` | `true`                    |
| `enable_cluster_creator_admin_permissions` | `true`        |

> Public endpoint access allows external tools (like kubectl) to connect to the cluster.

---

## 🌐 Networking

This EKS cluster is launched inside a pre-configured VPC.

- **VPC ID**: Pulled from `module.myapp-vpc.vpc_id`
- **Subnets**: Uses private subnets from `module.myapp-vpc.private_subnets`

---

## 🖥️ Managed Node Group

A single node group named `dev` is created with the following specs:

| Parameter       | Value          |
|----------------|----------------|
| `min_size`     | 1              |
| `max_size`     | 3              |
| `desired_size` | 3              |
| `instance_types` | `["t2.small"]` |

- Ideal for lightweight workloads or CI/testing environments.
- Nodes are automatically scaled between 1 and 3 EC2 instances.

---

## 🏷️ Tags

```hcl
tags = {
  environment = "development"
  application = "myapp"
}
```

These tags help categorize and track resources in AWS (e.g., for billing, filtering, etc.).

---

## 📌 Prerequisites

- Terraform v1.3+
- AWS CLI with configured credentials
- A pre-existing VPC and subnets module (`myapp-vpc`)
- kubectl (optional, for cluster access)

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
└── README.md
```

---

## ✅ Outputs (example)

You may define outputs such as:

```hcl
output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
```

---
