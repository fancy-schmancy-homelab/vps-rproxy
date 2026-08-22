# Azure VPS Reverse Proxy

This Terraform configuration provisions the Azure VPS used as the reverse proxy for the homelab. Ansible then installs and configures Caddy on the VM.

## Current configuration

- Azure Linux 4 arm64 image on `Standard_B2pls_v2`
- 32 GiB `StandardSSD_LRS` OS disk with host encryption and a Key Vault-backed disk encryption set
- Dedicated resource groups for the VM, network, Key Vault, and disk encryption set
- Dual-stack virtual network and subnet with static public IPv4 and IPv6 addresses
- Network security rules for ICMP, HTTPS over TCP/UDP, Tailscale direct connections on UDP `41641`, and Tailscale relay traffic on UDP `45129`
- Cloud-init installs `dnf` development packages, Homebrew, Zsh tooling, and Tailscale
- Tailscale is enabled with SSH, subnet routing for `10.100.1.0/24`, and exit-node advertising

## Terraform usage

Terraform Cloud is configured in `providers.tf` to use the `homelab-578` organization and the `hcp-terraform-azure-oidc` workspace.

Provide values for the required variables through Terraform Cloud variables or a local `.tfvars` file:

```hcl
resource_group_name_network        = "vps-rproxy-network-rg"
resource_group_name_vm             = "vps-rproxy-vm-rg"
resource_group_name_kv             = "vps-rproxy-kv-rg"
resource_group_name_disk_encryption = "vps-rproxy-disk-rg"
location                           = "southcentralus"
allowed_ip_addresses               = ["203.0.113.1"]
subscription_id                    = "your-subscription-id"
tenant_id                          = "your-tenant-id"
vm_admin_username                  = "thirstbeast"
admin_ssh_key                      = "ssh-ed25519 AAAA..."
TS_AUTH_KEY                        = "tskey-auth-..."
```

Run Terraform from this directory:

```sh
terraform init
terraform plan
terraform apply
```

Keep `admin_ssh_key`, `allowed_ip_addresses`, and `TS_AUTH_KEY` sensitive. The Tailscale auth key is rendered into cloud-init during VM creation.

## Ansible deployment

After the VM is reachable, install the Caddy role and run the playbook from the repository root:

```sh
ansible-galaxy install -r ansible/requirements.yaml
CF_TOKEN=... MAXMIND_ACCOUNT_ID=... MAXMIND_LICENSE_KEY=... MAXMIND_EDITION_IDS=... \
  ansible-playbook -i ansible/hosts.ini ansible/run.yaml
```

The Caddy configuration uses Cloudflare DNS-01 and geoblocks to the United States and Canada. It proxies:

| Hostname | Upstream |
| --- | --- |
| `jf.amireally.online` | `ultima-thule:8096` |
| `abs.amireally.online` | `ultima-thule:30067` |
| `oidc.amireally.online` | `ultima-thule:30218` |
| `nd.amireally.online` | `ultima-thule:4533` |

## Files

- `main.tf`: Azure resource groups, networking, public IPs, Key Vault, disk encryption, and VM
- `variables.tf`: Terraform input variables
- `providers.tf`: Terraform Cloud and Azure provider configuration
- `data.tf`: Azure subscription, service principal, and cloud-init data sources
- `cloudinit.tftpl`: VM bootstrap configuration
