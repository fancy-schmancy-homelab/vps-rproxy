# variables.tf
# Variables for Azure Container Registry
variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "location" {
  description = "Azure region for resources."
  type        = string
  default     = "southcentralus"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry."
  type        = string
}

variable "acr_sku" {
  description = "SKU for the Azure Container Registry."
  type        = string
  default     = "Basic"
}

variable "admin_enabled" {
  description = "Enable admin user for ACR."
  type        = bool
  default     = false
}
