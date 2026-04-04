# README for Azure VPS Reverse Proxy Terraform Module

This module provisions an Azure Virtual Private Server (VPS) configured as a reverse proxy using Terraform. It creates a Debian-based Linux VM with Docker, Tailscale VPN, and necessary networking/security configurations.

## Features

- **Virtual Machine**: Debian 13 (arm64) VM with encrypted OS disk
- **Networking**: Virtual network, subnet, public IPs (IPv4 and IPv6), network security group
- **Security**: Key Vault for disk encryption, disk encryption set, NSG rules for HTTPS and Tailscale
- **VPN**: Tailscale integration for secure remote access
- **Containerization**: Docker and Docker Compose pre-installed
- **Resource Organization**: Separate resource groups for VM, Key Vault, networking, and disk encryption

## Files

- `main.tf`: Resources for VM, networking, security, Key Vault, and disk encryption
- `variables.tf`: Input variables for configuration
- `providers.tf`: Terraform and provider configuration
- `data.tf`: Data sources for Azure subscription and service principal
- `cloudinit.tftpl`: Cloud-init template for VM initialization (installs Docker, Tailscale, etc.)

## Usage Example

```hcl
module "vps_rproxy" {
  source                        = "./az-terraform"
  resource_group_name_vm        = "vps-rproxy-vm-rg"
  resource_group_name_kv        = "vps-rproxy-kv-rg"
  resource_group_name_network   = "vps-rproxy-network-rg"
  resource_group_name_disk_encryption = "vps-rproxy-disk-rg"
  location                      = "southcentralus"
  allowed_ip_addresses          = ["203.0.113.1"]  # Your IP for Key Vault access
  subscription_id               = "your-subscription-id"
  tenant_id                     = "your-tenant-id"
  vm_admin_username             = "adminuser"
  admin_ssh_key                 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC..."
  TS_AUTH_KEY                   = "tskey-auth-..."
}
```

## Requirements

- Azure subscription with appropriate permissions
- Tailscale account for VPN access
- SSH key pair for VM access

## Notes

- The VM uses Debian 13 arm64 image
- Tailscale is configured with SSH access and exit node capabilities
- Network security allows ICMP, HTTPS (TCP/UDP), and Tailscale ports
- Disk encryption is enabled using Azure Key Vault
