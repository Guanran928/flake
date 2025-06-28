locals {
  cloudflare_zone_id    = cloudflare_zone.terraform_managed_resource_4b7a25e8fb5035c84820c26e454ed03d.id
  cloudflare_account_id = "af3504d3b07107975feaa691beae1553"
}

resource "cloudflare_zone" "terraform_managed_resource_4b7a25e8fb5035c84820c26e454ed03d" {
  account_id = local.cloudflare_account_id
  paused     = false
  plan       = "free"
  type       = "full"
  zone       = "ny4.dev"
}

resource "cloudflare_zone_settings_override" "terraform_managed_resource_4b7a25e8fb5035c84820c26e454ed03d" {
  zone_id = local.cloudflare_zone_id
  settings {
    ipv6 = "on"
    ssl  = "strict"
  }
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "blacksteel" {
  name       = "blacksteel"
  account_id = local.cloudflare_account_id
  secret     = local.secrets.cloudflare.tunnel_secret
}

resource "cloudflare_record" "terraform_managed_resource_e8a39752064c17b2c91d10edf667e322" {
  content = cloudflare_zero_trust_tunnel_cloudflared.blacksteel.cname
  name    = "pek0"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_3bb7c82777ada1dcafb0cd16ae22bcac" {
  content = module.vultr["sin0"].ipv4
  name    = "sin0"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_3393fe6c746c9f55d841397c77900a59" {
  content = module.vultr["sin0"].ipv6
  name    = "sin0"
  proxied = false
  ttl     = 1
  type    = "AAAA"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_3d75642939f7653d8d51dfb93c518b07" {
  content = module.aws["tyo0"].ipv4
  name    = "tyo0"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_03f9bd0678d8d76dc0e07892bc554393" {
  content = module.aws["tyo0"].ipv6
  name    = "tyo0"
  proxied = false
  ttl     = 1
  type    = "AAAA"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_8e75c63ef8a2f186ebd104abb4766a1d" {
  content = "guanran928.github.io"
  name    = "blog"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_9c931544d9033dee3e3ce376834217f9" {
  content = "tyo0.ny4.dev"
  name    = "cinny"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_06b8ff66458e32be7ac8b614c46c17fa" {
  content = "tyo0.ny4.dev"
  name    = "element"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_5423bda2c14dfc0785a3c58a4ebe537b" {
  content = "tyo0.ny4.dev"
  name    = "git"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_de1f6297937e0c3f5f4cd38ebf0f37dc" {
  content = "tyo0.ny4.dev"
  name    = "id"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_899b7a0a4077b12d429fae7221e3b5f0" {
  content = "sin0.ny4.dev"
  name    = "ip"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_a69da702b5de0b419265bb7e82d8ff72" {
  content = "pek0.ny4.dev"
  name    = "mastodon"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_bb02cc1465eb9b9876496b5825f32520" {
  content = "pek0.ny4.dev"
  name    = "matrix"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_42a460db1bab9041993a1fb19ac40aec" {
  content = "tyo0.ny4.dev"
  name    = "ntfy"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_07b0adf15b8e0a285b27e7998a4a7f91" {
  content = "tyo0.ny4.dev"
  name    = "ny4.dev"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_f3507181cd0965a1040216e6e5d94adf" {
  content = "tyo0.ny4.dev"
  name    = "pb"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_aab250e5d93fd4ceac718dbaaee7bdb3" {
  content = "tyo0.ny4.dev"
  name    = "prom"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_b674a8508d41cd2541e351943c3b247e" {
  content = "sin0.ny4.dev"
  name    = "reddit"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_365881b47c75cb8da9f515671a7e32f3" {
  content = "tyo0.ny4.dev"
  name    = "rss"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_6d07c0bd7a64a0cbb7230426ed7d503e" {
  content = "tyo0.ny4.dev"
  name    = "vault"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_e2500de6c975c90729b8f359361d8268" {
  content = "tyo0.ny4.dev"
  name    = "www"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "cxk" {
  content = "sin0.ny4.dev"
  name    = "cxk"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "bluesky" {
  content = "\"did=did:plc:s3ii4l6etpymuj5rzz2bondu\""
  name    = "_atproto"
  proxied = false
  ttl     = 1
  type    = "TXT"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "discord" {
  content = "\"dh=8da72697ecf86306cc5d5147711c3d0c12c11d71\""
  name    = "_atproto"
  proxied = false
  ttl     = 1
  type    = "TXT"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_856ec5e567960bf847db2e814f18168b" {
  content = "\"google-site-verification=wBL5EFnbnt9lt2j_BtcwlXTaBFlFT563mC1MkCscnR8\""
  name    = "ny4.dev"
  proxied = false
  ttl     = 3600
  type    = "TXT"
  zone_id = local.cloudflare_zone_id
}

