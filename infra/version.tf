terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    pocketid = {
      source = "trozz/pocketid"
    }
    sops = {
      source = "carlpett/sops"
    }
    vultr = {
      source = "vultr/vultr"
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
