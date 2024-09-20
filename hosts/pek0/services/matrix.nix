{ lib, config, ... }:
{
  services.matrix-synapse = {
    enable = true;
    withJemalloc = true;
    enableRegistrationScript = false;
    extraConfigFiles = [ config.sops.secrets."synapse/secret".path ];
    settings = {
      server_name = "ny4.dev";
      public_baseurl = "https://matrix.ny4.dev";
      presence.enabled = false; # tradeoff
      listeners = [
        {
          path = "/run/matrix-synapse/synapse.sock";
          type = "http";
          resources = lib.singleton {
            names = [
              "client"
              "federation"
            ];
            compress = true;
          };
        }
      ];

      # https://element-hq.github.io/synapse/latest/openid.html#keycloak
      oidc_providers = lib.singleton {
        idp_id = "keycloak";
        idp_name = "id.ny4.dev";
        issuer = "https://id.ny4.dev/realms/ny4";
        client_id = "synapse";
        client_secret_path = config.sops.secrets."synapse/oidc".path;
        scopes = [
          "openid"
          "profile"
        ];
        user_mapping_provider.config = {
          localpart_template = "{{ user.preferred_username }}";
          display_name_template = "{{ user.name }}";
        };
        backchannel_logout_enabled = true;
        allow_existing_users = true;
      };
    };
  };

  systemd.services.matrix-synapse = {
    environment = config.networking.proxy.envVars;
    serviceConfig.RuntimeDirectory = [ "matrix-synapse" ];
  };

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "matrix.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "subroute";
      routes = lib.singleton {
        match = lib.singleton {
          path = [
            "/_matrix/*"
            "/_synapse/*"
            "/health"
          ];
        };
        handle = lib.singleton {
          handler = "reverse_proxy";
          headers.request.set."X-Forwarded-Proto" = [ "https" ];
          upstreams = lib.singleton { dial = "unix//run/matrix-synapse/synapse.sock"; };
        };
      };
    };
  };
}
