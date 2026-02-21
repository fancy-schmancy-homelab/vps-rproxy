data "azuread_service_principal" "current" {
  display_name = "hcp-terraform-azure-oidc"
}

data "azurerm_subscription" "current" {}

data "template_file" "cloud-config" {
  template = "${file("cloudinit.tftpl")}"
  vars = {
    tailscale_auth_key = var.TS_AUTH_KEY
  }
}