# data "oci_core_instance_devices" "atlas_instance_devices" {
#   count       = var.num_instances
#   instance_id = oci_core_instance.atlas_instance[count.index].id
# }

# data "oci_identity_availability_domain" "ad" {
#   compartment_id = var.tenancy_ocid
#   ad_number      = var.availability_domain
# }

# data "template_file" "cloud-config" {
#   template = "${file("cloudinit.tftpl")}"
#   vars = {
#     tailscale_auth_key = var.TS_AUTH_KEY
#   }
# }