{ config, ... }:
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
          resources = [
            {
              names = [
                "client"
                "federation"
              ];
              compress = true;
            }
          ];
        }
      ];

      # https://element-hq.github.io/synapse/latest/openid.html#keycloak
      oidc_providers = [
        {
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
        }
      ];
    };
  };

  systemd.services.matrix-synapse = {
    environment = config.networking.proxy.envVars;
    serviceConfig.RuntimeDirectory = [ "matrix-synapse" ];
  };

  services.matrix-sliding-sync = {
    enable = true;
    environmentFile = config.sops.secrets."syncv3/environment".path;
    settings = {
      SYNCV3_SERVER = "/run/matrix-synapse/synapse.sock";
      SYNCV3_BINDADDR = "/run/matrix-sliding-sync/sync.sock";
    };
  };

  systemd.services.matrix-sliding-sync.serviceConfig = {
    RuntimeDirectory = [ "matrix-sliding-sync" ];
    SupplementaryGroups = [ "matrix-synapse" ];
  };
}
