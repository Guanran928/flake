{ lib, config, ... }:
{
  services.pocket-id = {
    enable = true;
    settings = {
      APP_URL = "https://id.ny4.dev";
      TRUST_PROXY = true;
      UNIX_SOCKET = "/run/pocket-id/pocket-id.sock";
      UNIX_SOCKET_MODE = "0660";

      DB_CONNECTION_STRING = "postgresql://pocket-id@/pocket-id?host=/run/postgresql";

      ANALYTICS_DISABLED = true;
    };
  };

  sops.secrets."pocket-id/environment" = {
    restartUnits = [ "pocket-id.service" ]; # ENCRYPTION_KEY
  };

  systemd.services.pocket-id.serviceConfig = {
    RuntimeDirectory = [ "pocket-id" ];
    RestrictAddressFamilies = [ "AF_UNIX" ];
    EnvironmentFile = config.sops.secrets."pocket-id/environment".path;
  };

  systemd.services.caddy.serviceConfig = {
    SupplementaryGroups = [ "pocket-id" ];
  };

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "id.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = [ { dial = "unix//run/pocket-id/pocket-id.sock"; } ];
    };
  };
}
