variable "CF_TOKEN" {
    description = "Cloudflare API Token with permissions to manage DNS records"
    type        = string
    sensitive   = true
}

variable "TS_AUTH_KEY" {
    description = "Auth key for Tailscale API"
    type        = string
    sensitive   = true
}

variable "DO_TOKEN" {
    description = "DigitalOcean API Token"
    type        = string
    sensitive   = true
}