# 📦 Infrastructure as Code with Terraform + Projects

Terraform is a powerful tool for defining, provisioning, and managing infrastructure as code (IaC). It works seamlessly alongside tools like Ansible and is widely adopted for deploying cloud environments in a repeatable and consistent way.

---

## 🚀 How Terraform Works

Terraform enables you to declare the desired infrastructure in configuration files. When you execute `terraform apply`, it:

- Creates the resources specified.
- Keeps track of the real-world infrastructure in a **state file**.
- Allows for easy updates by comparing current and desired configurations.

This process ensures your infrastructure is always in sync with your definitions.

---

## ✅ Benefits of Using Terraform

- 🕘 **Version Control**: Keep a complete history of infrastructure changes using Git.
- 🔁 **Environment Replication**: Easily spin up identical environments (e.g., dev, staging, prod).
- 🧹 **One-Command Teardown**: Clean infrastructure with `terraform destroy`.
- 👥 **Team-Friendly**: Everyone can see and modify infrastructure definitions in code.

---

## ☁️ Connecting to Cloud Providers

Terraform interacts with cloud platforms via APIs.

- In our case, we used **AWS** as the provider.
- Terraform uses provider-specific plugins (e.g., `aws`) to manage resources like EC2 instances.

---

## 📁 Key Terraform Files

| File                  | Description                                                                 |
|-----------------------|-----------------------------------------------------------------------------|
| `main.tf`             | Core configuration for your infrastructure                                  |
| `variables.tf`        | Declares input variables                                                    |
| `outputs.tf`          | Defines output values (e.g., IP addresses)                                  |
| `providers.tf`        | Specifies the provider(s) used                                              |
| `terraform.tfvars`    | Assigns values to input variables                                           |
| `terraform.tfstate`   | Stores current infrastructure state                                         |
| `terraform.tfstate.backup` | Automatic backup of state file                                     |
| `.terraform/`         | Contains downloaded providers and plugin binaries                           |

---

## 🛠️ Useful Terraform Commands

```bash
terraform init        # Initialize the project and download providers
terraform plan        # Preview the changes before applying
terraform apply       # Apply changes to real infrastructure
terraform destroy     # Remove all resources defined in configuration
terraform refresh     # Sync the state file with real-world infrastructure
```

---

## 🔌 Providers & Modules

- **Providers**: These are plugins that interface with specific platforms (e.g., AWS, DigitalOcean).
  - Declare them in `providers.tf` using the `provider` block.
  - Download them via `terraform init`.

- **Modules**: Reusable blocks of code grouping related resources (like a VPC or EC2 setup).
  - Accept inputs (variables) and return outputs (e.g., IPs).
  - Keep code DRY and organized.

---

## 🧮 Variables

Terraform supports multiple ways to provide variable values:

1. Automatically through `terraform.tfvars`
2. Via command line:
   ```bash
   terraform apply -var="instance_type=t2.micro"
   ```
3. Using environment variables prefixed with `TF_VAR_`
4. Through a custom file:
   ```bash
   terraform apply -var-file="custom.tfvars"
   ```

You can also set **default values** in `variables.tf`.

---

## ⚙️ Provisioners (Use with Caution)

Provisioners allow you to run scripts or commands **after a resource is created**.

| Type            | Description                                              |
|------------------|----------------------------------------------------------|
| `remote-exec`    | Executes commands on the remote resource (e.g., EC2)     |
| `local-exec`     | Runs a script or command locally                         |
| `file`           | Copies files from local machine to the resource          |

> ⚠️ **Note:** Terraform discourages provisioners as they can create inconsistencies. Prefer using Ansible or other config management tools.

---

## 🌐 Remote State Storage

- Store state in remote backends (like **S3**) to:
  - Share state across team members.
  - Enable automatic backups.
  - Support locking to prevent simultaneous changes.

---

## 🧠 Best Practices for Terraform

- 🔒 Modify infrastructure *only* via Terraform commands.
- ☁️ Use a **remote backend** with locking (e.g., S3 + DynamoDB).
- 💾 Enable **versioning** for the state file.
- 📦 Use **separate state files** per environment (dev/staging/prod).
- 🔄 Automate deployments via CI/CD pipelines.
- 🧾 Store code in Git repositories with clear commit history.
- ❌ Avoid manual changes to infrastructure outside Terraform.

---

## 📚 Summary

Terraform empowers you to automate and scale your infrastructure safely and repeatably. With modular design, state management, and strong provider ecosystem.
