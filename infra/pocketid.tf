# keep-sorted start block=yes newline_separated=yes
resource "pocketid_client" "immich" {
  name = "Immich"
  callback_urls = [
    "https://immich.ny4.dev/auth/login",
    "https://immich.ny4.dev/user-settings",
    # FIXME: broken by URL validation
    # The value "app.immich:///oauth-callback" is not a valid URL: must include scheme and host
    #
    # "app.immich:///oauth-callback",
  ]
  allowed_user_groups = [
    "a5dfd8ba-9b7b-4c6a-92d8-d60ce52fb19b",
  ]
  pkce_enabled = false
}

resource "pocketid_client" "mastodon" {
  name = "Mastodon"
  callback_urls = [
    "https://mastodon.ny4.dev/auth/auth/openid_connect/callback",
  ]
  pkce_enabled = false
}

resource "pocketid_client" "miniflux" {
  name = "Miniflux"
  callback_urls = [
    "https://rss.ny4.dev/oauth2/oidc/callback",
  ]
  pkce_enabled = false
}

resource "pocketid_client" "rustical" {
  name = "Rustical"
  callback_urls = [
    "https://cal.ny4.dev/frontend/login/oidc/callback",
  ]
  pkce_enabled = false
}

resource "pocketid_client" "synapse" {
  name = "Synapse"
  callback_urls = [
    "https://matrix.ny4.dev/_synapse/client/oidc/callback",
  ]
  pkce_enabled = false
}

resource "pocketid_user" "nyancat" {
  username   = "nyancat"
  email      = "guanran928@outlook.com"
  groups     = ["a5dfd8ba-9b7b-4c6a-92d8-d60ce52fb19b"]
  is_admin   = true
  first_name = "Guanran"
  last_name  = "Wang"
}
# keep-sorted end
