locals {
  nodes = {
    sin0 = {
      region = "sgp"
      plan   = "vhp-1c-1gb-amd"
      tags   = ["vultr", "proxy"]
    }
  }
}

resource "vultr_startup_script" "script" {
  name = "nixos"
  type = "pxe"
  script = base64encode(<<EOT
#!ipxe
set cmdline sshkey="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMmd/uqiBahzKcKMJ+gT3dkUIdrWQgudspsDchDlx1E/"
chain https://github.com/NickCao/netboot/releases/download/latest/ipxe
EOT
  )
}

module "vultr" {
  source   = "./modules/vultr"
  for_each = local.nodes
  hostname = each.key
  fqdn     = "${each.key}.ny4.dev"
  region   = each.value.region
  plan     = each.value.plan
  tags     = each.value.tags
  script   = vultr_startup_script.script.id
}

