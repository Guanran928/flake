resource "pocketid_client" "forgejo" {
  name = "Forgejo"
  callback_urls = [
    "https://git.ny4.dev/user/oauth2/id.ny4.dev/callback",
  ]
  pkce_enabled = false
}

resource "pocketid_client" "immich" {
  name = "Immich"
  callback_urls = [
    "https://immich.ny4.dev/auth/login",
    "https://immich.ny4.dev/user-settings",
    "app.immich:///oauth-callback",
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

resource "pocketid_client" "synapse" {
  name = "Synapse"
  callback_urls = [
    "https://matrix.ny4.dev/_synapse/client/oidc/callback",
  ]
  pkce_enabled = false
}
