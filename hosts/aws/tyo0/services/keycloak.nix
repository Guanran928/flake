{
  lib,
  pkgs,
  ports,
  ...
}:
let
  port = ports.keycloak;
in
{
  services.keycloak = {
    enable = true;
    settings = {
      cache = "local";
      hostname = "id.ny4.dev";
      http-enabled = true;
      http-host = "127.0.0.1";
      http-port = port;
      proxy-headers = "xforwarded";
    };
    database.passwordFile = toString (pkgs.writeText "password" "keycloak");
  };

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "id.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = [ { dial = "localhost:${toString port}"; } ];
    };
  };
}
