locals {
  vultr_nodes = {
    sin0 = {
      region = "sgp"
      plan   = "vhp-1c-1gb-amd"
      tags   = ["vultr", "proxy"]
    }
  }
}

# https://github.com/NickCao/netboot
resource "vultr_startup_script" "script" {
  name = "nixos"
  type = "pxe"
  script = base64encode(<<EOT
#!ipxe
set cmdline sshkey="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMmd/uqiBahzKcKMJ+gT3dkUIdrWQgudspsDchDlx1E/"
chain http://nixos.icu
EOT
  )
}

module "vultr" {
  source   = "./modules/vultr"
  for_each = local.vultr_nodes
  hostname = each.key
  fqdn     = "${each.key}.ny4.dev"
  region   = each.value.region
  plan     = each.value.plan
  tags     = each.value.tags
  script   = vultr_startup_script.script.id
}

resource "vultr_object_storage" "storage" {
  cluster_id = 4 # sgp1.vultrobjects.com
}
