# AWS Nginx Infrastructure with Terraform

This repository contains the Terraform configuration required to provision **AWS EC2 instances running Nginx** across `dev` and `qa` environments, using a modular and secure Infrastructure as Code (IaC) approach along with a **GitHub Actions** CI/CD pipeline authenticated via **WIF (Workload Identity Federation / OIDC)**.

The project is designed with **best practices**, separating configuration, reusable modules, and sensitive data.

---

## 📁 Project Structure

```text
.
├── .agents/                         # AI Agent context, rules & skills
│   ├── rules/
│   │   └── terraform-standards.md
│   └── skills/
│       └── terraform-ops/
│           └── SKILL.md
├── .github/
│   └── workflows/
│       └── terraform.yml            # GitHub Actions CI/CD pipeline (WIF)
├── .terraform/                      # Terraform working directory (ignored)
├── admin_user_accesskeys_*/         # AWS access keys (ignored)
├── nginx_server_module/             # Reusable Nginx EC2 module
│   ├── 00.variables.tf
│   ├── 01.provider.tf
│   ├── 02.ec2.tf
│   ├── 03.key.tf
│   ├── 04.sg.tf
│   └── 99.outputs.tf
├── .gitignore
├── AGENTS.md                        # AI Agent guidelines
├── GEMINI.md                        # Project context & architecture
├── main.tf                          # Root module
├── variables.tf                     # Root input variables
└── README.md
```

---

## 🚀 Prerequisites for Local Execution and Pipeline

Before proceeding to the deployment pipeline, you must initialize Terraform locally by first authenticating with AWS and exporting the session credentials to your environment:

1. **Log in to AWS:**
   ```bash
   aws login
   ```

2. **Export AWS credentials as environment variables:**
   ```bash
   eval $(aws.exe configure export-credentials --format env)
   ```

3. **Initialize Terraform locally:**
   ```bash
   terraform init
   ```

Once `terraform init` is completed locally, the environment is ready to proceed with the pipeline.
