terraform {
  cloud {
    organization = "homelab-578"
    workspaces {
      name = "vps-rproxy-oci"
    }
  }
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key      = var.oci_private_key
  region           = var.oci_region
}