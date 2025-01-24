resource "keycloak_realm" "ny4" {
  realm                       = "ny4"
  default_signature_algorithm = "RS256"
  remember_me                 = true
}

resource "keycloak_openid_client" "forgejo" {
  realm_id            = keycloak_realm.ny4.id
  client_id           = "forgejo"
  name                = "Forgejo"
  access_type         = "CONFIDENTIAL"
  base_url            = "https://git.ny4.dev"
  valid_redirect_uris = ["https://git.ny4.dev/user/oauth2/id.ny4.dev/callback"]
  web_origins         = ["https://git.ny4.dev"]
}

resource "keycloak_openid_client" "grafana" {
  realm_id            = keycloak_realm.ny4.id
  client_id           = "grafana"
  name                = "Grafana"
  access_type         = "CONFIDENTIAL"
  base_url            = "https://grafana.ny4.dev"
  valid_redirect_uris = ["https://grafana.ny4.dev/login/generic_oauth"]
  web_origins         = ["https://grafana.ny4.dev"]
}

resource "keycloak_openid_client" "mastodon" {
  realm_id            = keycloak_realm.ny4.id
  client_id           = "mastodon"
  name                = "Mastodon"
  access_type         = "CONFIDENTIAL"
  base_url            = "https://mastodon.ny4.dev"
  valid_redirect_uris = ["https://mastodon.ny4.dev/auth/auth/openid_connect/callback"]
  web_origins         = ["https://mastodon.ny4.dev"]
}

resource "keycloak_openid_client" "miniflux" {
  realm_id            = keycloak_realm.ny4.id
  client_id           = "miniflux"
  name                = "Miniflux"
  access_type         = "CONFIDENTIAL"
  base_url            = "https://rss.ny4.dev"
  valid_redirect_uris = ["https://rss.ny4.dev/oauth2/oidc/callback"]
  web_origins         = ["https://rss.ny4.dev/oauth2/oidc/redirect"]
}

resource "keycloak_openid_client" "synapse" {
  realm_id               = keycloak_realm.ny4.id
  client_id              = "synapse"
  name                   = "Synapse"
  access_type            = "CONFIDENTIAL"
  valid_redirect_uris    = ["https://matrix.ny4.dev/_synapse/client/oidc/callback"]
  web_origins            = ["https://matrix.ny4.dev"]
  backchannel_logout_url = "https://matrix.ny4.dev/_synapse/client/oidc/backchannel_logout"
}
