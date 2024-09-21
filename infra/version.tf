terraform {
  required_providers {
    vultr = {
      source = "registry.terraform.io/vultr/vultr"
    }
    sops = {
      source = "registry.terraform.io/carlpett/sops"
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
