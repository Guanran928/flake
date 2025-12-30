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
  dns_records = {
    # keep-sorted start
    "bird-lg" = "tyo0.ny4.dev"
    "cinny"   = "tyo0.ny4.dev"
    "cxk"     = "tyo0.ny4.dev"
    "element" = "tyo0.ny4.dev"
    "ip"      = "tyo0.ny4.dev"
    "nix"     = "tyo0.ny4.dev"
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
  }
}

resource "cloudflare_dns_record" "cname_records" {
  for_each = local.dns_records

  content = each.value
  name    = "${each.key}.ny4.dev"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "pek0" {
  content = "${cloudflare_zero_trust_tunnel_cloudflared.pek0.id}.cfargotunnel.com"
  name    = "pek0.ny4.dev"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "tyo0_v4" {
  content = "178.239.125.6"
  name    = "tyo0.ny4.dev"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "tyo0_v6" {
  content = "2602:fd6f:1f:3ed::324"
  name    = "tyo0.ny4.dev"
  proxied = false
  ttl     = 1
  type    = "AAAA"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "tyo1_v4" {
  content = "178.239.126.230"
  name    = "tyo1.ny4.dev"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "tyo1_v6" {
  content = "2602:fd6f:1f:6a7::121"
  name    = "tyo1.ny4.dev"
  proxied = false
  ttl     = 1
  type    = "AAAA"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "lax0_v4" {
  content = "154.17.237.246"
  name    = "lax0.ny4.dev"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "lax0_v6" {
  content = "2605:52c0:1:ca6:1014:f5ff:fe0c:513f"
  name    = "lax0.ny4.dev"
  proxied = false
  ttl     = 1
  type    = "AAAA"
  zone_id = local.cloudflare_zone_id
}


resource "cloudflare_dns_record" "blog" {
  content = "guanran928.github.io"
  name    = "blog.ny4.dev"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}


resource "cloudflare_dns_record" "apex" {
  content = "tyo0.ny4.dev"
  name    = "ny4.dev"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}


resource "cloudflare_dns_record" "bluesky" {
  content = "\"did=did:plc:s3ii4l6etpymuj5rzz2bondu\""
  name    = "_atproto.ny4.dev"
  proxied = false
  ttl     = 1
  type    = "TXT"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "discord" {
  content = "\"dh=8da72697ecf86306cc5d5147711c3d0c12c11d71\""
  name    = "_atproto.ny4.dev"
  proxied = false
  ttl     = 1
  type    = "TXT"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "google_search_console" {
  content = "\"google-site-verification=wBL5EFnbnt9lt2j_BtcwlXTaBFlFT563mC1MkCscnR8\""
  name    = "ny4.dev"
  proxied = false
  ttl     = 3600
  type    = "TXT"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "bing_webmaster" {
  content = "verify.bing.com"
  name    = "c721047d80432b0bbe1f6856f5f17970.ny4.dev"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}
