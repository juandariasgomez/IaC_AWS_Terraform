# Terraform & Security Standards (AWS IaC)

## Structure & Modularity
1. **Root Module**:
   - `main.tf`: Contains only the S3 backend configuration, `module` blocks (`nginx_server_dev`, `nginx_server_qa`), and root `output` blocks.
   - `variables.tf`: Contains all `variable` declarations required by `main.tf`.
2. **Child Module (`nginx_server_module/`)**:
   - Maintain the numbered file structure for logical reading order:
     - `00.variables.tf`: Module input variables.
     - `01.provider.tf`: AWS provider (`us-east-1`).
     - `02.ec2.tf`: EC2 instance and Nginx `user_data` provisioning.
     - `03.key.tf`: SSH key pair (`aws_key_pair`).
     - `04.sg.tf`: Security Group (`aws_security_group`).
     - `99.outputs.tf`: Module outputs (`server_public_ip`, `server_public_dns`).

## Tagging Policy
Every resource created in AWS must include the `tags` block with:
- `Name`
- `Environment`
- `Owner = "juandariasgomez@gmail.com"`
- `Team = "DevOps"`
- `Project = "webinar"`

## Variables & Parameterization in CI/CD
- Any new variable added to `variables.tf` that needs to be configurable from GitHub Actions must be exposed in `.github/workflows/terraform.yml` under `on.workflow_dispatch.inputs` and mapped as a `TF_VAR_<variable_name>` environment variable.
