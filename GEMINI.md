# Project Context: IaC AWS Terraform (Nginx Infrastructure)

## Overview
This repository contains the Infrastructure as Code (IaC) in **Terraform** to provision **AWS EC2 instances running Nginx** in `dev` and `qa` environments, along with an automated **GitHub Actions** CI/CD pipeline authenticated via **WIF (Workload Identity Federation / OIDC)**.

## Architecture & Project Structure

```text
.
├── .agents/
│   ├── rules/
│   │   └── terraform-standards.md       # Terraform architecture rules & standards
│   └── skills/
│       └── terraform-ops/
│           └── SKILL.md                 # Runbook for local & CI/CD operations
├── .github/
│   └── workflows/
│       └── terraform.yml                # CI/CD pipeline with WIF & parameterized inputs
├── nginx_server_module/                 # Reusable module for EC2 + Nginx
│   ├── 00.variables.tf                  # Module input variables
│   ├── 01.provider.tf                   # AWS provider configuration (us-east-1)
│   ├── 02.ec2.tf                        # aws_instance resource with Nginx user_data
│   ├── 03.key.tf                        # aws_key_pair resource (reads <server_name>.key.pub)
│   ├── 04.sg.tf                         # Security Group (ports 22 SSH & 80 HTTP)
│   └── 99.outputs.tf                    # Public IP & public DNS outputs
├── AGENTS.md                            # Primary guidelines for AI agents
├── GEMINI.md                            # Project context for Gemini / Antigravity
├── README.md                            # General repository documentation
├── main.tf                              # Root module (S3 backend, dev/qa module calls & outputs)
└── variables.tf                         # Root module variable declarations
```

## Key Technical Details

1. **Remote State (S3 Backend)**:
   - Bucket: `bucket-devsecops2026`
   - Key: `terraform-infrastructure/terraform.tfstate`
   - Region: `us-east-1`

2. **Root Module (`main.tf` and `variables.tf`)**:
   - Declares variables `ami_id`, `instance_type`, `server_name`, and `environment` in `variables.tf` (do not declare `variable` blocks inside `main.tf`).
   - Instantiates two modules from `./nginx_server_module`:
     - `nginx_server_dev`: environment `dev`, server `${var.server_name}-dev`.
     - `nginx_server_qa`: environment `qa`, server `${var.server_name}-qa`.

3. **SSH Key Management (`03.key.tf`)**:
   - The `aws_key_pair` resource reads the `${var.server_name}.key.pub` file from the root directory using `file("${var.server_name}.key.pub")`.
   - `*.key` and `*.pub` files are ignored in `.gitignore` for security.
   - Both locally and in the GitHub Actions pipeline, SSH keys must be generated before running `terraform plan` or `terraform apply`.

4. **Mandatory Tagging Policy**:
   All AWS resources include the following standard tags:
   - `Name`: Resource name based on `var.server_name`
   - `Environment`: `var.environment` (`dev` / `qa`)
   - `Owner`: `juandariasgomez@gmail.com`
   - `Team`: `DevOps`
   - `Project`: `webinar`

5. **CI/CD Pipeline (`.github/workflows/terraform.yml`)**:
   - **AWS Authentication**: Uses WIF / OIDC (`aws-actions/configure-aws-credentials@v4`) assuming the IAM role stored in the `AWS_ROLE_ARN` secret with `id-token: write` permission.
   - **Parameters (`workflow_dispatch`)**: Accepts `action` (`plan`, `apply`, `destroy`), `ami_id`, `instance_type`, and `server_name`, injecting them via `TF_VAR_*` environment variables.

6. **Git Operations in this Environment (Windows / WSL)**:
   - The remote repository uses SSH (`git@github.com:juandariasgomez/IaC_AWS_Terraform.git`).
   - To run `git push` from this Windows environment, use `wsl git push origin main` to leverage the SSH agent and keys configured in WSL.
