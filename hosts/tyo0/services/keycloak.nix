{ lib, pkgs, ... }:
{
  services.keycloak = {
    enable = true;
    settings = {
      cache = "local";
      hostname = "id.ny4.dev";
      http-host = "127.0.0.1";
      http-port = 8800;
      proxy = "edge";
    };
    database.passwordFile = toString (pkgs.writeText "password" "keycloak");
  };

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton {
      host = [ "id.ny4.dev" ];
    };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = [ { dial = "localhost:8800"; } ];
    };
  };
}
