data "azuread_service_principal" "current" {
  display_name = "hcp-terraform-azure-oidc"
}

data "azurerm_subscription" "current" {}