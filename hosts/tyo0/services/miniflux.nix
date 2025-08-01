{ lib, config, ... }:
{
  # https://miniflux.app/docs/howto.html#systemd-socket-activation
  systemd = {
    sockets.miniflux = {
      description = "Miniflux Socket";
      wantedBy = [ "sockets.target" ];
      requiredBy = [ "miniflux.service" ];
      listenStreams = [ "/run/miniflux.sock" ];
      socketConfig.NoDelay = true;
    };
    services.miniflux = {
      serviceConfig.NonBlocking = true;
    };
  };

  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.sops.secrets."miniflux/environment".path;
    config = {
      CREATE_ADMIN = 0;
      BASE_URL = "https://rss.ny4.dev";

      DISABLE_LOCAL_AUTH = "true";
      OAUTH2_USER_CREATION = "true";
      OAUTH2_PROVIDER = "oidc";
      OAUTH2_CLIENT_ID = "f3dce354-5be8-42dd-8579-4773d2f32ce0";
      # OAUTH2_CLIENT_SECRET = "replace_me"; # EnvironmentFile
      OAUTH2_REDIRECT_URL = "https://rss.ny4.dev/oauth2/oidc/callback";
      OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://id.ny4.dev";
    };
  };

  sops.secrets."miniflux/environment".restartUnits = [ "miniflux.service" ];

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "rss.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = [ { dial = "unix//run/miniflux.sock"; } ];
    };
  };
}
