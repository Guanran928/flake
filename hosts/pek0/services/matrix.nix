{
  lib,
  config,
  ports,
  ...
}:
let
  port = ports.matrix-synapse;
in
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
      listeners = lib.singleton {
        inherit port;
        type = "http";
        bind_addresses = [ "127.0.0.1" ];
        tls = false;
        x_forwarded = true;
        resources = [
          {
            compress = true;
            names = [
              "client"
              "federation"
            ];
          }
        ];
      };

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

      app_service_config_files = [ "/run/credentials/matrix-synapse.service/telegram" ];
    };
  };

  sops.secrets = {
    "synapse/secret" = {
      restartUnits = [ "matrix-synapse.service" ];
      owner = config.systemd.services.matrix-synapse.serviceConfig.User;
    };
    "synapse/oidc" = {
      restartUnits = [ "matrix-synapse.service" ];
      owner = config.systemd.services.matrix-synapse.serviceConfig.User;
    };
  };

  systemd.services.matrix-synapse = {
    environment = config.networking.proxy.envVars;
    serviceConfig.RuntimeDirectory = [ "matrix-synapse" ];
    serviceConfig.LoadCredential = [ "telegram:/var/lib/mautrix-telegram/telegram-registration.yaml" ];
  };

  systemd.services.caddy.serviceConfig.SupplementaryGroups = [ "matrix-synapse" ];

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
          upstreams = lib.singleton { dial = "127.0.0.1:${toString port}"; };
        };
      };
    };
  };
}
