{
  lib,
  pkgs,
  config,
  ...
}:
{
  services.mastodon = {
    enable = true;
    localDomain = "ny4.dev";
    streamingProcesses = 1;
    mediaAutoRemove.olderThanDays = 14;
    # FIXME: this doesn't exist
    smtp = {
      createLocally = false;
      fromAddress = "mastodon@ny4.dev";
    };
    extraConfig = rec {
      SINGLE_USER_MODE = "true";
      WEB_DOMAIN = "mastodon.ny4.dev";

      OMNIAUTH_ONLY = "true";
      OIDC_ENABLED = "true";
      OIDC_CLIENT_ID = "0ebb58af-9bc9-47ee-9cdd-4ca05c17bc9f";
      # OIDC_CLIENT_SECRET # EnvironmentFile
      OIDC_DISCOVERY = "true";
      OIDC_DISPLAY_NAME = "id.ny4.dev";
      OIDC_ISSUER = "https://id.ny4.dev";
      OIDC_REDIRECT_URI = "https://${WEB_DOMAIN}/auth/auth/openid_connect/callback";
      OIDC_SCOPE = "openid,profile,email";
      OIDC_SECURITY_ASSUME_EMAIL_IS_VERIFIED = "true";
      OIDC_UID_FIELD = "preferred_username";
    };
  };

  sops.secrets."mastodon/environment".restartUnits = [ "mastodon-web.service" ];

  systemd.services.mastodon-web = {
    environment = config.networking.proxy.envVars;
    serviceConfig.EnvironmentFile = [ config.sops.secrets."mastodon/environment".path ];
  };

  # Let traffic go through proxy
  systemd.services.mastodon-sidekiq-all.environment = config.networking.proxy.envVars;

  systemd.services.caddy.serviceConfig.SupplementaryGroups = [ "mastodon" ];

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "mastodon.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "subroute";
      routes = [
        {
          match = lib.singleton { path = [ "/api/v1/streaming/*" ]; };
          handle = lib.singleton {
            handler = "reverse_proxy";
            headers.request.set."X-Forwarded-Proto" = [ "https" ];
            upstreams = lib.singleton { dial = "unix//run/mastodon-streaming/streaming-1.socket"; };
          };
        }
        {
          match = lib.singleton { path = [ "/system/*" ]; };
          handle = [
            {
              handler = "rewrite";
              strip_path_prefix = "/system";
            }
            {
              handler = "file_server";
              root = "/var/lib/mastodon/public-system";
            }
          ];
        }
        {
          handle = [
            {
              handler = "file_server";
              root = "${pkgs.mastodon}/public";
              pass_thru = true;
            }
            {
              handler = "reverse_proxy";
              headers.request.set."X-Forwarded-Proto" = [ "https" ];
              upstreams = lib.singleton { dial = "unix//run/mastodon-web/web.socket"; };
            }
          ];
        }
      ];
    };
  };

  services.caddy.settings.apps.http.servers.srv0.errors.routes = lib.singleton {
    match = lib.singleton { host = [ "mastodon.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "subroute";
      routes = [
        {
          handle = lib.singleton {
            handler = "rewrite";
            uri = "500.html";
          };
        }
        {
          handle = lib.singleton {
            handler = "file_server";
            root = "${pkgs.mastodon}/public";
          };
        }
      ];
    };
  };

}
