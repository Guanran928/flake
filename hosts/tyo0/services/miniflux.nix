{config, ...}: {
  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.sops.secrets."miniflux/environment".path;
    config = {
      LISTEN_ADDR = "127.0.0.1:9300";
      BASE_URL = "https://rss.ny4.dev";

      OAUTH2_PROVIDER = "oidc";
      OAUTH2_CLIENT_ID = "miniflux";
      # OAUTH2_CLIENT_SECRET = "replace_me"; # EnvironmentFile
      OAUTH2_REDIRECT_URL = "https://rss.ny4.dev/oauth2/oidc/callback";
      OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://id.ny4.dev/realms/ny4";
    };
  };
}
