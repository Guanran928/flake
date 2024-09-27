locals {
  aws_nodes = {
    tyo0 = {
      region = "ap-northeast-1a"
      plan   = "micro_3_0"
      tags   = ["aws", "proxy"]
    }
  }
}

module "aws" {
  source   = "./modules/aws"
  for_each = local.aws_nodes
  hostname = each.key
  fqdn     = "${each.key}.ny4.dev"
  region   = each.value.region
  plan     = each.value.plan
  tags     = each.value.tags
}
