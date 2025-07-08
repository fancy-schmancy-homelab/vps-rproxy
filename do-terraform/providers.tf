terraform {
  cloud {
    organization = "homelab-578"

    workspaces {
      name = "vps-rproxy"
    }
  }
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.DO_TOKEN
}