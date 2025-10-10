data "sops_file" "secrets" {
  source_file = "secrets.yaml"
}

locals {
  secrets = yamldecode(data.sops_file.secrets.raw)
}

provider "cloudflare" {
  api_token = local.secrets.cloudflare.api_token
}

provider "pocketid" {
  base_url  = "https://id.ny4.dev"
  api_token = local.secrets.pocketid.api_token
}

provider "vultr" {
  api_key = local.secrets.vultr.api_key
}
