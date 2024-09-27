variable "hostname" {
  type = string
}

variable "fqdn" {
  type = string
}

variable "region" {
  type = string
}

variable "plan" {
  type = string
}

variable "tags" {
  type = list(string)
}

terraform {
  required_providers {
    aws = {
      source = "registry.terraform.io/hashicorp/aws"
    }
  }
}

resource "aws_lightsail_instance" "server" {
  availability_zone = var.region
  bundle_id         = var.plan
  name              = var.hostname
  tags              = zipmap(var.tags, [for _ in var.tags : null])

  blueprint_id    = "debian_12" # nixos-anywhere
  ip_address_type = "dualstack"
  lifecycle {
    ignore_changes = [
      name,
    ]
  }
}

output "ipv4" {
  value = aws_lightsail_instance.server.public_ip_address
}

output "ipv6" {
  value = aws_lightsail_instance.server.ipv6_addresses
}

output "fqdn" {
  value = var.fqdn
}

output "tags" {
  value = var.tags
}
