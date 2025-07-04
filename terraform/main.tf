resource "digitalocean_droplet" "droplet" {
  image     = "ubuntu-24-10-x64"
  name      = "atl1-terraform-caddy"
  region    = "atl1"
  size      = "s-1vcpu-1gb"
  # doctl -t dop_v1_token compute ssh-key list
  ssh_keys  = [49040097]
  user_data = templatefile("digitalocean.tftpl", { tailscale_auth_key = var.TS_AUTH_KEY })
}