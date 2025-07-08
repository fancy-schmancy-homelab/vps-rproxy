variable "fingerprint" {
  description = "Fingerprint of oci api private key"
  type        = string
}

variable "oci_private_key" {
  description = "Path to oci api private key used"
  type        = string
}

variable "oci_region" {
  description = "The oci region where resources will be created"
  type        = string
}

variable "tenancy_ocid" {
  description = "Tenancy ocid where to create the sources"
  type        = string
}

variable "user_ocid" {
  description = "Ocid of user that terraform will use to create the resources"
  type        = string
}

variable "compartment_ocid" {
  description = "Compartment ocid where to create all resources"
  type        = string
}

variable "instance_name" {
  description = "Name of the instance."
  type        = string
}

variable "instance_ad_number" {
  default     = 1
  description = "The availability domain number of the instance. If none is provided, it will start with AD-1 and continue in round-robin."
  type        = number
}

variable "instance_count" {
  default     = 1
  description = "Number of identical instances to launch from a single module."
  type        = number
}

variable "instance_state" {
  default     = "RUNNING"
  description = "(Updatable) The target state for the instance. Could be set to RUNNING or STOPPED."
  type        = string

  validation {
    condition     = contains(["RUNNING", "STOPPED"], var.instance_state)
    error_message = "Accepted values are RUNNING or STOPPED."
  }
}

variable "ssh_public_keys" {
  default     = null
  description = "Public SSH keys to be included in the ~/.ssh/authorized_keys file for the default user on the instance. To provide multiple keys, see docs/instance_ssh_keys.adoc."
  type        = string
}

variable "ssh_private_key" {
  default     = null
  description = "Private SSH key for remote execution."
  type        = string
}

variable "auto_iptables" {
  default     = false
  description = "Automatically configure iptables to allow inbound traffic."
  type        = bool
}

variable "assign_public_ip" {
  default     = false
  description = "Whether the VNIC should be assigned a public IP address."
  type        = bool
}

variable "public_ip" {
  default     = "NONE"
  description = "Whether to create a Public IP to attach to primary vnic and which lifetime. Valid values are NONE, RESERVED or EPHEMERAL."
  type        = string
}

variable "num_instances" {
  default = "1"
}

variable "availability_domain" {
  default     = 3
  description = "Availability Domain of the instance"
  type        = number
}

variable "instance_shape" {
  default     = "VM.Standard.A1.Flex"
  description = "The shape of an instance."
  type        = string
}

variable "instance_ocpus" {
  default     = 2
  description = "Number of OCPUs"
  type        = number
}

variable "instance_shape_config_memory_in_gbs" {
  default     = 12
  description = "Amount of Memory (GB)"
  type        = number
}

variable "instance_source_type" {
  default     = "image"
  description = "The source type for the instance."
  type        = string
}

variable "boot_volume_size_in_gbs" {
  default     = "50"
  description = "Bott volume size in GBs"
  type        = number
}

variable "TS_AUTH_KEY" {
  default     = null
  description = "Tailscale auth key to use for the instance."
  type        = string
  
}

variable "instance_image_ocid" {
  type = map(string)

  # See https://docs.us-phoenix-1.oraclecloud.com/images/
  # Canonical-Ubuntu-24.04-Minimal-aarch64-2025.05.20-0
  default = {
    af-johannesburg-1 = "ocid1.image.oc1.af-johannesburg-1.aaaaaaaa3m7ontupfeqaasqwjhucb4y4amn2wqsipihwdoitbdpbzcvo353q"
    ap-chuncheon-1    = "ocid1.image.oc1.ap-chuncheon-1.aaaaaaaak5xncypd54fmojufbnjem2j46prursn7yoxiexgkpls6x2lefrqa"
    ap-hyderabad-1    = "ocid1.image.oc1.ap-hyderabad-1.aaaaaaaavyrtp6mduwxevgdwachmvivtqxspl2hkkayqy5xl2vzoy4olv43q"
    ap-melbourne-1    = "ocid1.image.oc1.ap-melbourne-1.aaaaaaaanbnap2fwnuxtgxpkhp2xotbu2wipk4qfvhcuu7iujb4et3z4ypca"
    ap-mumbai-1       = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaaruxx3luzrgnji6xjbu6atltjnpp56pd2o5hkgkjcbugwqnwkz4xa"
    ap-osaka-1        = "ocid1.image.oc1.ap-osaka-1.aaaaaaaarj3uumqyeyav675adbze6u32fil6brloj22kpbthpax4yekenk3a"
    ap-seoul-1        = "ocid1.image.oc1.ap-seoul-1.aaaaaaaaazfjopmrguoqqpxwa6fydk2konro3ptyqzsd3uozbswyfvu2f7kq"
    ap-singapore-1    = "ocid1.image.oc1.ap-singapore-1.aaaaaaaavpms5nv7qmalnorgvemrgumiln5en2o6xmxllosxu5cdaqmgycyq"
    ap-sydney-1       = "ocid1.image.oc1.ap-sydney-1.aaaaaaaagv4sgoph76vx6umntk73shyufi5z3m7uv4oy6cwggxp37krptozq"
    ap-tokyo-1        = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaaisn6jecs7yji64mbpxehm6oqx3zkmugmavimvusij267wcxguera"
    ca-montreal-1     = "ocid1.image.oc1.ca-montreal-1.aaaaaaaajfog72fa4hzkg5srmqu2nf7tkfsg6be4mxt7ysb4jpjktryzibuq"
    ca-toronto-1      = "ocid1.image.oc1.ca-toronto-1.aaaaaaaaex2o6tijfek4h2hfooswy6lpkdbu7jhy5wzsqgyonflkqskgbz3a"
    eu-amsterdam-1    = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaa3gfgt2mhzbo6eijoksmosc4rdczrln7kkhku77dx53hrzgrheovq"
    eu-frankfurt-1    = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaa6y7yd2njc7ezdngpeippyod2ncrfajgpglikjs5r6vgm3qoobua"
    eu-madrid-1       = "ocid1.image.oc1.eu-madrid-1.aaaaaaaahrjnisjqfxwpzalufemwrau2czg3qgkvvpot4a3wcnq2cpf4w77q"
    eu-marseille-1    = "ocid1.image.oc1.eu-marseille-1.aaaaaaaa2qkdrijwmraccct3uy2bhsne6isceuej6o4egtwovqosoq37u3va"
    eu-milan-1        = "ocid1.image.oc1.eu-milan-1.aaaaaaaavddyuvk3yswepwevocdxyyrsez6sdlf4ylvtyrqcpck44gwjac4q"
    eu-paris-1        = "ocid1.image.oc1.eu-paris-1.aaaaaaaav2bsnves3vtt33mfzp7va6i6dr6ffc5gwydwbyttwjc5tznwpu3a"
    eu-stockholm-1    = "ocid1.image.oc1.eu-stockholm-1.aaaaaaaahcgqm7zgztt4ud4koxepqfobmmtk2cgcu6br2tgmhis3uypkfmtq"
    eu-zurich-1       = "ocid1.image.oc1.eu-zurich-1.aaaaaaaabm626uv45muqbspagtapmddhu4rot7edgyauda5uqqigs6cjswxa"
    il-jerusalem-1    = "ocid1.image.oc1.il-jerusalem-1.aaaaaaaalq7slgybdg5hwwzcn5cxvhnwftb7qhycl6e7f4xdlxae2rn35spq"
    me-abudhabi-1     = "ocid1.image.oc1.me-abudhabi-1.aaaaaaaanvjrsodr43itcsfytaflnebrsekhwj66nhkmiewnkonigprdjh2q"
    me-dubai-1        = "ocid1.image.oc1.me-dubai-1.aaaaaaaasyonbw47amyubub5xk7sbews27xv5lq57bqv5k6e7brjbicswbpa"
    me-jeddah-1       = "ocid1.image.oc1.me-jeddah-1.aaaaaaaa74f7rxngvxy5qzyc3y3obr7o7gkdia7cxk22ib6mcrstuvbm73ha"
    mx-monterrey-1    = "ocid1.image.oc1.mx-monterrey-1.aaaaaaaaavdt53wnyllidxvphbionkk25jwluhqoku5js2e7idw44rnepava"
    mx-queretaro-1    = "ocid1.image.oc1.mx-queretaro-1.aaaaaaaaqv6ow3fyag4awkjw77vgwmltzzejywnf3ejhwaowypajvbv5eggq"
    sa-bogota-1       = "ocid1.image.oc1.sa-bogota-1.aaaaaaaabqzspsd34mccui37c74qhupqcbhvcstymlhqv4yk5c22couhe4za"
    sa-santiago-1     = "ocid1.image.oc1.sa-santiago-1.aaaaaaaadwbh4qjh6uvj4w74oogb7ahhjmes3jtmcjubupaq3fyyaktalrpq"
    sa-saopaulo-1     = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaaa2igbbbrqdy7rrjwjclhbmgbmyoxgpn4ip3bgn6yq6uvgxw4hdeq"
    sa-valparaiso-1   = "ocid1.image.oc1.sa-valparaiso-1.aaaaaaaaaihx7h345dcra563jebavnrhh2mhj7c3flckfpbqa6awqayqrngq"
    sa-vinhedo-1      = "ocid1.image.oc1.sa-vinhedo-1.aaaaaaaaxcinbgunir36l4dde3p77hkmn5xfppf3zndioetn5mgzbpli6wcq"
    uk-cardiff-1      = "ocid1.image.oc1.uk-cardiff-1.aaaaaaaay5nhvqasiarpfbxpbrw4d3y4p6gbkt43nvky4aijcrfb72gplz7a"
    uk-london-1       = "ocid1.image.oc1.uk-london-1.aaaaaaaaqifmrbmvwh3yiwcqhjnxjt3mhxswtuejrcsbsu4hbdu5nbw3564a"
    us-ashburn-1      = "ocid1.image.oc1.iad.aaaaaaaa7okdhcic7y34xenpuxdmdypn2ehdd23fkqjef6toanzghm3m2kna"
    us-chicago-1      = "ocid1.image.oc1.us-chicago-1.aaaaaaaadpnzxhwjxnjjdawzxqcni2o3tt7bbgyfvw2s72sbsh63bo7ikwyq"
    us-phoenix-1      = "ocid1.image.oc1.phx.aaaaaaaabbv5z2up7vvnejka5nk76ttezyqhb4lcxbppkjmy2nh2hmpspkqa"
    us-sanjose-1      = "ocid1.image.oc1.us-sanjose-1.aaaaaaaabdvhlsfxadj56k3jswe3h55hrx3fcavk76ubndaaemmgv6kl4dma"
  }
}