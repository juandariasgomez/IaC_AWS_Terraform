# Agent Guidelines & Project Context

This project provisions AWS infrastructure (EC2 instances with Nginx for `dev` and `qa`) using **Terraform** and **GitHub Actions**.

Refer to `@[GEMINI.md](./GEMINI.md)` for the complete architecture and always follow these operational guidelines:

## Core Rules
- **Documentation Language**: Keep all documentation and `.md` files written in **English**.
- **Variable Separation**: Keep root `variable` declarations exclusively in `variables.tf` and module variables in `nginx_server_module/00.variables.tf`. Do not add `variable` blocks inside `main.tf`.
- **Module File Naming Convention**: Inside `nginx_server_module/`, preserve the numeric prefix convention (`00.variables.tf`, `01.provider.tf`, `02.ec2.tf`, `03.key.tf`, `04.sg.tf`, `99.outputs.tf`).
- **Security & Secrets**: Never commit `.tfstate`, `.tfvars`, `*.key`, `*.pem`, `*.pub` files or AWS credentials to the repository.
- **Pipeline Authentication**: Always maintain the WIF (OIDC) scheme with `role-to-assume: ${{ secrets.AWS_ROLE_ARN }}` and never use static keys (`AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`) in GitHub Actions.
- **Repository Push**: When the user asks to `push`, execute `wsl git push origin main` to use the SSH configuration in WSL.
