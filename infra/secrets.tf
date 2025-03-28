data "sops_file" "secrets" {
  source_file = "secrets.yaml"
}

locals {
  secrets = yamldecode(data.sops_file.secrets.raw)
}

provider "vultr" {
  api_key = local.secrets.vultr.api_key
}

provider "aws" {
  region     = "ap-northeast-1"
  access_key = local.secrets.aws.access_key
  secret_key = local.secrets.aws.secret_key
}

provider "cloudflare" {
  api_token = local.secrets.cloudflare.api_token
}

provider "keycloak" {
  client_id     = "terraform"
  client_secret = local.secrets.keycloak.token
  realm         = "ny4"
  url           = "https://id.ny4.dev"
}
