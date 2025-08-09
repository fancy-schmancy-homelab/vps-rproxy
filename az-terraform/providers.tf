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
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted_key_vaults = true
    }
  }
  use_cli = false

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}
