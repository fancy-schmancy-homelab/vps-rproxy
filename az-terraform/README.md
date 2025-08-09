# README for Azure Container Registry Terraform Module

This module creates an Azure Container Registry (ACR) using Terraform.

## Files
- `main.tf`: Resources for ACR and resource group
- `variables.tf`: Input variables
- `outputs.tf`: Output values
- `providers.tf`: Provider configuration

## Usage Example
```hcl
module "acr" {
  source              = "./az-terraform"
  resource_group_name = "my-acr-rg"
  location            = "eastus"
  acr_name            = "myuniquenameacr"
  acr_sku             = "Basic"
  admin_enabled       = true
}
```

## Outputs
- `acr_login_server`: The login server URL
- `acr_admin_username`: Admin username (if enabled)
- `acr_admin_password`: Admin password (if enabled)
