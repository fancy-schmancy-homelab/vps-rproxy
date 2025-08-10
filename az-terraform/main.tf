# main.tf
# Terraform configuration for Azure Container Registry

# resource "azurerm_resource_group" "acr_rg" {
#   name     = var.resource_group_name_acr
#   location = var.location
# }

resource "azurerm_resource_group" "vm_rg" {
  name     = var.resource_group_name_vm
  location = var.location
}

resource "azurerm_resource_group" "kv_rg" {
  name     = var.resource_group_name_kv
  location = var.location
}

resource "azurerm_resource_group" "network_rg" {
  name     = var.resource_group_name_network
  location = var.location
}

# resource "azurerm_container_registry" "acr" {
#   name                = var.acr_name
#   resource_group_name = azurerm_resource_group.acr_rg.name
#   location            = azurerm_resource_group.acr_rg.location
#   sku                 = var.acr_sku
#   admin_enabled       = var.admin_enabled
# }

resource "azurerm_virtual_network" "vm_network" {
  name                = "vm-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name
}

resource "azurerm_subnet" "vm_subnet" {
  name                 = "vm-subnet"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.vm_network.name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on = [ azurerm_virtual_network.vm_network ]
  service_endpoints = ["Microsoft.KeyVault"]
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "vm-nic"
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [ azurerm_subnet.vm_subnet ]
}

resource "azurerm_key_vault" "kv" {
  name                        = "vps-rproxy-kv"
  location                    = azurerm_resource_group.kv_rg.location
  resource_group_name         = azurerm_resource_group.kv_rg.name
  tenant_id                   = data.azurerm_subscription.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  enabled_for_disk_encryption = true
  enabled_for_deployment      = true
  public_network_access_enabled = true
  # network_acls {
  #   default_action = "Deny"
  #   bypass         = "AzureServices"
  #   ip_rules       = var.allowed_ip_addresses
  #   virtual_network_subnet_ids = [
  #     azurerm_subnet.vm_subnet.id
  #   ]
  # }
}

resource "azurerm_key_vault_access_policy" "vm_kv_policy" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_subscription.current.tenant_id
  object_id    = data.azuread_service_principal.current.object_id

  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "Purge",
    "Recover",
    "Update",
    "List",
    "Decrypt",
    "Sign",
    "GetRotationPolicy",
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete"
  ]
}

resource "azurerm_key_vault_key" "vm_disk_encryption" {
  name         = "vm-disk-encryption-key"
  key_vault_id = azurerm_key_vault.kv.id
  key_type     = "RSA"
  key_size     = 4096
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
  depends_on = [ azurerm_key_vault_access_policy.vm_kv_policy ]
}

resource "azurerm_disk_encryption_set" "vm_disk_encryption" {
  name                = "vm-disk-encryption-set"
  resource_group_name = azurerm_resource_group.kv_rg.name
  location            = azurerm_resource_group.kv_rg.location
  key_vault_key_id    = azurerm_key_vault_key.vm_disk_encryption.id
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_key_vault_access_policy" "vm_disk_access_policy" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = azurerm_disk_encryption_set.vm_disk_encryption.identity[0].tenant_id
  object_id    = azurerm_disk_encryption_set.vm_disk_encryption.identity[0].principal_id

  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "Purge",
    "Recover",
    "Update",
    "List",
    "Decrypt",
    "Sign",
  ]
}

# # Terraform configuration for Azure Linux Virtual Machine
# # This VM will be used to run the reverse proxy

# resource "azurerm_linux_virtual_machine" "vm" {
#   name                = "vps-rproxy-vm"
#   resource_group_name = azurerm_resource_group.vm_rg.name
#   location            = azurerm_resource_group.vm_rg.location
#   size                = "Standard_B2als_v2"
#   admin_username      = var.vm_admin_username

#   network_interface_ids = [azurerm_network_interface.vm_nic.id]

#   admin_ssh_key {
#     username   = var.vm_admin_username
#     public_key = var.admin_ssh_key  # Adjust path to your SSH public key
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "StandardSSD_LRS"
#     disk_size_gb         = 32
#     disk_encryption_set_id = # azurerm_disk_encryption_set.vm_disk_encryption.id
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "24.04-LTS"
#     version   = "latest"
#   }
# }