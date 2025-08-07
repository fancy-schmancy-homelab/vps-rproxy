# providers.tf
# Provider configuration for Azure
terraform {
  cloud {
    organization = "homelab-578"

    workspaces {
      name = "vps-rproxy"
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
}
