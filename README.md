# vps-rproxy

This repo builds a VPS in DigitalOcean or Oracle Cloud Infrastructure (OCI) for use with reverse proxying to my homelab box.  It then uses Ansible to deploy Caddy to the server and sets up the config.

Huge thanks to IronicBadger for getting me started with the idea of reverse proxying over Tailscale.  His code snippets helped me get started, then I made adaptations for my own needs.

Another round of thanks to anotherglitchinthematrix for the terraform module for OCI free tier.