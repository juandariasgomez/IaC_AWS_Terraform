####### tfstate #######

terraform {
  backend "s3" {
    bucket         = "bucket-devsecops2026"
    key            = "terraform-infrastructure/terraform.tfstate"
    region         = "us-east-1"
  }
}

####### modulos #######
module "nginx_server_dev" {
    source = "./nginx_server_module"

    ami_id           = var.ami_id
    instance_type    = var.instance_type
    server_name      = "${var.server_name}-dev"
    environment      = "dev"
}

module "nginx_server_qa" {
    source = "./nginx_server_module"

    ami_id           = var.ami_id
    instance_type    = var.instance_type
    server_name      = "${var.server_name}-qa"
    environment      = "qa"
}

#######  output ####### 
output "nginx_dev_ip" {
  description = "Dirección IP pública de la instancia EC2"
  value       = module.nginx_server_dev.server_public_ip
}

output "nginx_dev_dns" {
  description = "DNS público de la instancia EC2"
  value       = module.nginx_server_dev.server_public_dns
}

output "nginx_qa_ip" {
  description = "Dirección IP pública de la instancia EC2"
  value       = module.nginx_server_qa.server_public_ip
}

output "nginx_qa_dns" {
  description = "DNS público de la instancia EC2"
  value       = module.nginx_server_qa.server_public_dns
}