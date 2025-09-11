{ lib,  ... }:
{
  services.pocket-id = {
    enable = true;
    settings = {
      APP_URL = "https://id.ny4.dev";
      TRUST_PROXY = true;
      UNIX_SOCKET = "/run/pocket-id/pocket-id.sock";
      UNIX_SOCKET_MODE = "0660";

      DB_PROVIDER = "postgres";
      DB_CONNECTION_STRING = "user=pocket-id dbname=pocket-id host=/run/postgresql";

      ANALYTICS_DISABLED = true;
    };
  };

  systemd.services = {
    pocket-id.serviceConfig.RuntimeDirectory = [ "pocket-id" ];
    pocket-id.serviceConfig.RestrictAddressFamilies = [ "AF_UNIX" ];
    caddy.serviceConfig.SupplementaryGroups = [ "pocket-id" ];
  };

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "id.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = [ { dial = "unix//run/pocket-id/pocket-id.sock"; } ];
    };
  };
}
