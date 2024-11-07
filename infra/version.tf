terraform {
  required_providers {
    vultr = {
      source = "registry.terraform.io/vultr/vultr"
    }
    sops = {
      source = "registry.terraform.io/carlpett/sops"
    }
    aws = {
      source = "registry.terraform.io/hashicorp/aws"
    }
    cloudflare = {
      source = "registry.terraform.io/cloudflare/cloudflare"
    }
  }

  encryption {
    method "aes_gcm" "default" {
      keys = key_provider.pbkdf2.default
    }

    state {
      method   = method.aes_gcm.default
      enforced = true
    }
  }
}
