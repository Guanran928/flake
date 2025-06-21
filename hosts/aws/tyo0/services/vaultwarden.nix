{
  lib,
  config,
  ports,
  ...
}:
let
  port = ports.vaultwarden;
in
{
  services.vaultwarden = {
    enable = true;
    environmentFile = config.sops.secrets."vaultwarden/environment".path;
    config = {
      DOMAIN = "https://vault.ny4.dev";
      IP_HEADER = "X-Forwarded-For";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = port;

      EMERGENCY_ACCESS_ALLOWED = false;
      SENDS_ALLOWED = false;
      SIGNUPS_ALLOWED = false;
      ORG_CREATION_USERS = "none";
    };
  };

  sops.secrets."vaultwarden/environment".restartUnits = [ "vaultwarden.service" ];

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "vault.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = [ { dial = "localhost:${toString port}"; } ];
    };
  };
}
