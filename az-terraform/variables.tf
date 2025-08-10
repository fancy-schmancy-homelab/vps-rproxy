# variables.tf
# Variables for Azure Container Registry
# variable "resource_group_name_acr" {
#   description = "Name of the resource group."
#   type        = string
# }

variable "resource_group_name_network" {
  description = "Name of the resource group for networking resources."
  type        = string
}

variable "resource_group_name_vm" {
  description = "Name of the resource group for VMs."
  type        = string
}

variable "resource_group_name_kv" {
  description = "Name of the resource group for Key Vault."
  type        = string
}

variable "resource_group_name_disk_encryption" {
  description = "Name of the resource group for disk encryption."
  type        = string
}

variable "location" {
  description = "Azure region for resources."
  type        = string
  default     = "southcentralus"
}

# variable "acr_name" {
#   description = "Name of the Azure Container Registry."
#   type        = string
# }

# variable "acr_sku" {
#   description = "SKU for the Azure Container Registry."
#   type        = string
#   default     = "Basic"
# }

# variable "admin_enabled" {
#   description = "Enable admin user for ACR."
#   type        = bool
#   default     = false
# }

variable "allowed_ip_addresses" {
  description = "List of allowed IP addresses for Key Vault access."
  type        = list(string)
  sensitive   = true
}

variable "subscription_id" {
  description = "Azure Subscription ID."
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID."
  type        = string
}

variable "vm_admin_username" {
  description = "Admin username for the virtual machine."
  type        = string
}

variable "admin_ssh_key" {
  description = "SSH public key for the admin user."
  type        = string
  sensitive   = true
}

variable "TS_AUTH_KEY" {
  default     = null
  description = "Tailscale auth key to use for the instance."
  type        = string
  sensitive   = true
}