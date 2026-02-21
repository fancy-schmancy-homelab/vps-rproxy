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

resource "azurerm_resource_group" "disk_encryption_rg" {
  name     = var.resource_group_name_disk_encryption
  location = var.location
}

resource "azurerm_virtual_network" "vm_network" {
  name                = "vm-network"
  address_space       = ["10.0.0.0/16", "2404:f800:8000:122::/63"]
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name
  depends_on          = [azurerm_resource_group.network_rg]
}

resource "azurerm_network_security_group" "vm_nsg" {
  name                = "vm-nsg"
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name
  depends_on          = [azurerm_resource_group.network_rg]
}

# resource "azurerm_network_security_rule" "allow_ssh" {
#   name                       = "AllowSSH"
#   priority                   = 1000
#   direction                  = "Inbound"
#   access                     = "Allow"
#   protocol                   = "Tcp"
#   source_address_prefixes    = var.allowed_ip_addresses
#   source_port_range          = "*"
#   destination_port_range     = "22"
#   destination_address_prefix = "*"
#   resource_group_name         = azurerm_resource_group.network_rg.name
#   network_security_group_name = azurerm_network_security_group.vm_nsg.name
# }

resource "azurerm_network_security_rule" "allow_icmp" {
  name                        = "AllowICMP"
  priority                    = 1010
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.network_rg.name
  network_security_group_name = azurerm_network_security_group.vm_nsg.name
  depends_on                  = [azurerm_network_security_group.vm_nsg]
}

resource "azurerm_network_security_rule" "allow_https" {
  name                        = "AllowHTTPS"
  priority                    = 1020
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_port_range      = "443"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.network_rg.name
  network_security_group_name = azurerm_network_security_group.vm_nsg.name
  depends_on                  = [azurerm_network_security_group.vm_nsg]
}

resource "azurerm_network_security_rule" "allow_https_udp" {
  name                        = "AllowHTTPS-UDP"
  priority                    = 1030
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_port_range      = "443"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.network_rg.name
  network_security_group_name = azurerm_network_security_group.vm_nsg.name
  depends_on                  = [azurerm_network_security_group.vm_nsg]
}

resource "azurerm_network_security_rule" "allow_tailscale_udp" {
  name                        = "AllowTailscale-UDP"
  priority                    = 1040
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_port_range      = "41641"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.network_rg.name
  network_security_group_name = azurerm_network_security_group.vm_nsg.name
  depends_on                  = [azurerm_network_security_group.vm_nsg]
}

# resource "azurerm_network_security_rule" "drop_traffic" {
#   name                       = "Drop-All-Traffic"
#   priority                   = 4000
#   direction                  = "Inbound"
#   access                     = "Deny"
#   protocol                   = "*"
#   source_address_prefix      = "*"
#   source_port_range          = "*"
#   destination_port_range     = "*"
#   destination_address_prefix = "*"
#   resource_group_name         = azurerm_resource_group.network_rg.name
#   network_security_group_name = azurerm_network_security_group.vm_nsg.name
# }

resource "azurerm_subnet" "vm_subnet" {
  name                 = "vm-subnet"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.vm_network.name
  address_prefixes     = ["10.0.1.0/24", "2404:f800:8000:122::/64"]
  depends_on           = [azurerm_virtual_network.vm_network]
  service_endpoints    = ["Microsoft.KeyVault"]
}

resource "azurerm_subnet_network_security_group_association" "vm_subnet_nsg" {
  subnet_id                 = azurerm_subnet.vm_subnet.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
  depends_on                = [azurerm_network_security_group.vm_nsg, azurerm_subnet.vm_subnet]
}

resource "random_string" "random" {
  length  = 16
  special = false
  upper   = false
  lower   = true
  numeric = true
}

resource "azurerm_public_ip" "vm_public_ip" {
  name                = "vps-rproxy-public-ip"
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name
  allocation_method   = "Static"

  domain_name_label = "a${random_string.random.result}" # Ensure this is unique across Azure
  depends_on        = [azurerm_resource_group.network_rg]
}

resource "azurerm_public_ip" "vm_public_ipv6" {
  name                = "vps-rproxy-public-ipv6"
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name
  allocation_method   = "Static"

  domain_name_label = "a6${random_string.random.result}" # Ensure this is unique across Azure
  ip_version        = "IPv6"
  depends_on        = [azurerm_resource_group.network_rg]
}


resource "azurerm_network_interface" "vm_nic" {
  name                = "vm-nic"
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }

  ip_configuration {
    name                          = "internal-ipv6"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ipv6.id
    private_ip_address_version    = "IPv6"
  }
  depends_on = [azurerm_subnet.vm_subnet, azurerm_public_ip.vm_public_ip, azurerm_public_ip.vm_public_ipv6]
}


resource "azurerm_key_vault" "kv" {
  name                          = "vps-rproxy-kv"
  depends_on                    = [azurerm_resource_group.kv_rg]
  location                      = azurerm_resource_group.kv_rg.location
  resource_group_name           = azurerm_resource_group.kv_rg.name
  tenant_id                     = data.azurerm_subscription.current.tenant_id
  sku_name                      = "standard"
  soft_delete_retention_days    = 7
  purge_protection_enabled      = true
  enabled_for_disk_encryption   = true
  enabled_for_deployment        = true
  public_network_access_enabled = true
  rbac_authorization_enabled    = true
  # network_acls {
  #   default_action = "Deny"
  #   bypass         = "AzureServices"
  #   ip_rules       = var.allowed_ip_addresses
  #   virtual_network_subnet_ids = [
  #     azurerm_subnet.vm_subnet.id
  #   ]
  # }
}

resource "azurerm_role_assignment" "service_principal_kv_access" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_service_principal.current.object_id
}

# resource "azurerm_key_vault_access_policy" "vm_kv_policy" {
#   key_vault_id = azurerm_key_vault.kv.id
#   tenant_id    = data.azurerm_subscription.current.tenant_id
#   object_id    = data.azuread_service_principal.current.object_id

#   key_permissions = [
#     "Create",
#     "Delete",
#     "Get",
#     "Purge",
#     "Recover",
#     "Update",
#     "List",
#     "Decrypt",
#     "Sign",
#     "GetRotationPolicy",
#   ]

#   secret_permissions = [
#     "Get",
#     "List",
#     "Set",
#     "Delete"
#   ]
# }

resource "azurerm_key_vault_key" "vm_disk_encryption" {
  name         = "vm-disk-encryption-key-1"
  key_vault_id = azurerm_key_vault.kv.id
  key_type     = "RSA"
  key_size     = 4096
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
  depends_on = [ azurerm_key_vault.kv, azurerm_role_assignment.service_principal_kv_access ]
}

resource "azurerm_disk_encryption_set" "vm_disk_encryption" {
  name                = "vm-disk-encryption-set-1"
  resource_group_name = azurerm_resource_group.disk_encryption_rg.name
  location            = azurerm_resource_group.disk_encryption_rg.location
  key_vault_key_id    = azurerm_key_vault_key.vm_disk_encryption.versionless_id

  auto_key_rotation_enabled = true

  identity {
    type = "SystemAssigned"
  }
  depends_on = [ azurerm_key_vault_key.vm_disk_encryption ]
}

# resource "azurerm_key_vault_access_policy" "vm_disk_access_policy" {
#   key_vault_id = azurerm_key_vault.kv.id
#   tenant_id    = data.azurerm_disk_encryption_set.vm_disk_encryption.identity[0].tenant_id
#   object_id    = data.azurerm_disk_encryption_set.vm_disk_encryption.identity[0].principal_id

#   key_permissions = [
#     "Create",
#     "Delete",
#     "Get",
#     "Purge",
#     "Recover",
#     "Update",
#     "List",
#     "Decrypt",
#     "Sign",
#     "UnwrapKey",
#     "WrapKey"
#   ]
# }

# # # Terraform configuration for Azure Linux Virtual Machine
# # # This VM will be used to run the reverse proxy

# resource "azurerm_linux_virtual_machine" "vm" {
#   name                = "vps-rproxy-vm"
#   resource_group_name = azurerm_resource_group.vm_rg.name
#   location            = azurerm_resource_group.vm_rg.location
#   size                = "Standard_B2als_v2"
#   admin_username      = var.vm_admin_username
#   encryption_at_host_enabled = true
#   vtpm_enabled = true
#   secure_boot_enabled = true

#   provision_vm_agent = true
#   allow_extension_operations = true
#   reboot_setting = "Always"
#   patch_assessment_mode = "AutomaticByPlatform"
#   patch_mode = "AutomaticByPlatform"

#   network_interface_ids = [azurerm_network_interface.vm_nic.id]

#   custom_data = "${base64encode(data.template_file.cloud-config.rendered)}"  # Adjust path to your cloud-init file

#   admin_ssh_key {
#     username   = var.vm_admin_username
#     public_key = var.admin_ssh_key  # Adjust path to your SSH public key
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "StandardSSD_LRS"
#     disk_size_gb         = 32
#     disk_encryption_set_id = data.azurerm_disk_encryption_set.vm_disk_encryption.id
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "ubuntu-24_04-lts"
#     sku       = "server"
#     version   = "latest"
#   }
# }

# resource "azurerm_virtual_machine_extension" "vm_extension" {
#   name                 = "AzurePolicyforLinux"
#   virtual_machine_id   = azurerm_linux_virtual_machine.vm.id
#   publisher            = "Microsoft.GuestConfiguration"
#   type                 = "ConfigurationForLinux"
#   type_handler_version = "1.0"
#   auto_upgrade_minor_version = "true"
# }