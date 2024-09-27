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
