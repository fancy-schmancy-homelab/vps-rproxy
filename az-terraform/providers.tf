# providers.tf
# Provider configuration for Azure
terraform {
  cloud {
    organization = "homelab-578"

    workspaces {
      name = "hcp-terraform-azure-oidc"
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  use_cli = false

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}
