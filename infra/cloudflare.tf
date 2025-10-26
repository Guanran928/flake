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

resource "cloudflare_zero_trust_tunnel_cloudflared" "blacksteel" {
  name          = "blacksteel"
  account_id    = local.cloudflare_account_id
  tunnel_secret = local.secrets.cloudflare.tunnel_secret
}

resource "cloudflare_dns_record" "pek0" {
  content = "${cloudflare_zero_trust_tunnel_cloudflared.blacksteel.id}.cfargotunnel.com"
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

resource "cloudflare_dns_record" "blog" {
  content = "guanran928.github.io"
  name    = "blog.ny4.dev"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "cinny" {
  content = "tyo0.ny4.dev"
  name    = "cinny.ny4.dev"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "element" {
  content = "tyo0.ny4.dev"
  name    = "element.ny4.dev"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "git" {
  content = "pek0.ny4.dev"
  name    = "git.ny4.dev"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "id" {
  content = "pek0.ny4.dev"
  name    = "id.ny4.dev"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "ip" {
  content = "tyo0.ny4.dev"
  name    = "ip.ny4.dev"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "mastodon" {
  content = "pek0.ny4.dev"
  name    = "mastodon.ny4.dev"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "matrix" {
  content = "pek0.ny4.dev"
  name    = "matrix.ny4.dev"
  proxied = true
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

resource "cloudflare_dns_record" "pb" {
  content = "pek0.ny4.dev"
  name    = "pb.ny4.dev"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "prom" {
  content = "pek0.ny4.dev"
  name    = "prom.ny4.dev"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "rss" {
  content = "pek0.ny4.dev"
  name    = "rss.ny4.dev"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "vault" {
  content = "pek0.ny4.dev"
  name    = "vault.ny4.dev"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "www" {
  content = "tyo0.ny4.dev"
  name    = "www.ny4.dev"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "cxk" {
  content = "tyo0.ny4.dev"
  name    = "cxk.ny4.dev"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "immich" {
  content = "pek0.ny4.dev"
  name    = "immich.ny4.dev"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "cal" {
  content = "pek0.ny4.dev"
  name    = "cal.ny4.dev"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "bird-lg" {
  content = "tyo0.ny4.dev"
  name    = "bird-lg.ny4.dev"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cloudflare_zone_id
}

resource "cloudflare_dns_record" "nix" {
  content = "tyo0.ny4.dev"
  name    = "nix.ny4.dev"
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
