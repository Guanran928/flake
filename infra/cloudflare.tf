locals {
  cloudflare_zone_id    = cloudflare_zone.ny4.id
  cloudflare_account_id = "af3504d3b07107975feaa691beae1553"
}

resource "cloudflare_zone" "ny4" {
  account = {
    id = local.cloudflare_account_id
  }
  paused = false
  type   = "full"
  name   = "ny4.dev"
}

resource "cloudflare_zone_setting" "ipv6" {
  zone_id    = local.cloudflare_zone_id
  setting_id = "ipv6"
  value      = "on"
}

resource "cloudflare_zone_setting" "ssl" {
  zone_id    = local.cloudflare_zone_id
  setting_id = "ssl"
  value      = "strict"
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "pek0" {
  name          = "pek0"
  account_id    = local.cloudflare_account_id
  tunnel_secret = local.secrets.cloudflare.tunnel_secret
}

locals {
  a_records = {
    "lax0" = "154.17.237.246"
    "tyo0" = "178.239.126.230"
  }

  aaaa_records = {
    "lax0" = "2605:52c0:1:ca6:1014:f5ff:fe0c:513f"
    "tyo0" = "2602:fd6f:1f:6a7::121"
  }

  cname_records = {
    "blog"                             = "guanran928.github.io"
    "c721047d80432b0bbe1f6856f5f17970" = "verify.bing.com"
  }

  cname_records_proxied = {
    # keep-sorted start
    "@"       = "tyo0.ny4.dev"
    "bird-lg" = "tyo0.ny4.dev"
    "cinny"   = "tyo0.ny4.dev"
    "cxk"     = "tyo0.ny4.dev"
    "element" = "tyo0.ny4.dev"
    "ip"      = "tyo0.ny4.dev"
    "nix"     = "tyo0.ny4.dev"
    "sub"     = "tyo0.ny4.dev"
    "www"     = "tyo0.ny4.dev"
    # keep-sorted end

    # keep-sorted start
    "cal"      = "pek0.ny4.dev"
    "id"       = "pek0.ny4.dev"
    "immich"   = "pek0.ny4.dev"
    "mastodon" = "pek0.ny4.dev"
    "matrix"   = "pek0.ny4.dev"
    "pb"       = "pek0.ny4.dev"
    "rss"      = "pek0.ny4.dev"
    "vault"    = "pek0.ny4.dev"
    # keep-sorted end

    "prom" = "lax0.ny4.dev"
    "pek0" = "${cloudflare_zero_trust_tunnel_cloudflared.pek0.id}.cfargotunnel.com"
  }

  txt_records = {
    "_atproto" = "did=did:plc:s3ii4l6etpymuj5rzz2bondu"
    "_discord" = "dh=8da72697ecf86306cc5d5147711c3d0c12c11d71"
    "@"        = "google-site-verification=wBL5EFnbnt9lt2j_BtcwlXTaBFlFT563mC1MkCscnR8"
  }
}

resource "cloudflare_dns_record" "a_records" {
  for_each = local.a_records

  name    = each.key
  content = each.value
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "aaaa_records" {
  for_each = local.aaaa_records

  name    = each.key
  content = each.value
  proxied = false
  ttl     = 1
  type    = "AAAA"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "cname_records" {
  for_each = local.cname_records

  name    = each.key == "@" ? "ny4.dev" : each.key
  content = each.value
  proxied = false
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "cname_records_proxied" {
  for_each = local.cname_records_proxied

  name    = each.key == "@" ? "ny4.dev" : each.key
  content = each.value
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "txt_records" {
  for_each = local.txt_records

  name    = each.key == "@" ? "ny4.dev" : each.key
  content = "\"${each.value}\""
  proxied = false
  ttl     = 1
  type    = "TXT"
  zone_id = local.cloudflare_zone_id
}
