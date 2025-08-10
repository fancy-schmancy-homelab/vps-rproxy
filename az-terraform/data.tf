data "azuread_service_principal" "current" {
  display_name = "hcp-terraform-azure-oidc"
}

data "azurerm_subscription" "current" {}

data "azurerm_disk_encryption_set" "vm_disk_encryption" {
  name = "vm-disk-encryption-set"
  resource_group_name = azurerm_resource_group.disk_encryption_rg.name
}