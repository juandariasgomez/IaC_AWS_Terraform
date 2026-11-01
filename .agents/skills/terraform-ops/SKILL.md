---
name: terraform-ops
description: >-
  Runbook and procedures to initialize, plan, deploy, and destroy the Terraform infrastructure
  locally or via the GitHub Actions WIF pipeline, as well as pushing changes via SSH.
---

# Terraform & CI/CD Operations

Use this guide when the user asks to initialize Terraform locally, generate SSH keys required by the module, run the pipeline, or push changes to GitHub.

## 1. Local Terraform Execution

Before running Terraform commands locally or moving to the pipeline:

1. **Authenticate with AWS CLI**:
   ```bash
   aws login
   ```
2. **Export credentials to the terminal environment**:
   ```bash
   eval $(aws.exe configure export-credentials --format env)
   ```
3. **Generate local SSH key pairs (if they do not exist)**:
   The module `nginx_server_module/03.key.tf` requires `.key.pub` files in the root directory:
   ```bash
   ssh-keygen -t rsa -b 2048 -f "nginx-server-dev.key" -N ""
   ssh-keygen -t rsa -b 2048 -f "nginx-server-qa.key" -N ""
   ```
4. **Initialize and validate Terraform**:
   ```bash
   terraform init
   terraform fmt -check
   terraform validate
   terraform plan
   ```

## 2. Execution in GitHub Actions (WIF / OIDC)

The `.github/workflows/terraform.yml` file supports:
- **Automatic execution**: On `push` or `pull_request` to `main`/`master`.
- **Manual execution (`workflow_dispatch`)**: Accepts the following parameters:
  - `action`: `plan`, `apply`, or `destroy`
  - `ami_id`: AMI ID (default: `ami-0440d3b780d96b29d`)
  - `instance_type`: `t3.micro`, `t3.small`, `t3.medium`, `t2.micro`
  - `server_name`: Prefix for the `dev` and `qa` servers (default: `nginx-server`)

**GitHub Requirement**:
- The `AWS_ROLE_ARN` secret must be configured in the repository pointing to the IAM Role with the OIDC Identity Provider (`token.actions.githubusercontent.com`).

## 3. Git Push Workflow (SSH via WSL)

On this Windows machine, the authorized SSH keys for GitHub (`git@github.com:juandariasgomez/IaC_AWS_Terraform.git`) reside in the WSL environment:

1. Stage and commit changes as usual:
   ```powershell
   git add .
   git commit -m "<message>"
   ```
2. Execute push through WSL:
   ```powershell
   wsl git push origin main
   ```
