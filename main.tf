# Terraform provider for core services.

terraform {
  required_providers {
    proxmox   = {
      source  = "bpg/proxmox"
      version = ">= 0.70.0"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://${var.pve_host}:8006"
  api_token = var.pve_api_token
  insecure  = true
}
