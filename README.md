# AWS Nginx Infrastructure with Terraform

This repository contains the Terraform configuration required to provision an **AWS EC2 instance running Nginx**, using a modular and secure infrastructure approach.

The project is designed with **best practices**, separating configuration, modules, and sensitive data.

---

## 📁 Project Structure

```text
.
├── .terraform/                     # Terraform working directory (ignored)
├── admin_user_accesskeys_*/         # AWS access keys (ignored)
├── nginx_server_module/             # Reusable Nginx EC2 module
│   ├── 00.variables.tf
│   ├── 01.provider.tf
│   ├── 02.ec2.tf
│   ├── 03.key.tf
│   ├── 04.sg.tf
│   └── 99.outputs.tf
├── .gitignore
├── main.tf                          # Root module
└── README.md
```

---

## 🚀 Requisitos previos para ejecución local y Pipeline

Antes de pasar al pipeline de despliegue, es necesario inicializar Terraform en local autenticándose primero en AWS y exportando las credenciales de sesión al entorno:

1. **Iniciar sesión en AWS:**
   ```bash
   aws login
   ```

2. **Exportar las credenciales de AWS a variables de entorno:**
   ```bash
   eval $(aws.exe configure export-credentials --format env)
   ```

3. **Inicializar Terraform en local:**
   ```bash
   terraform init
   ```

Una vez completado el `terraform init` localmente, el entorno estará listo para proceder con el pipeline.

