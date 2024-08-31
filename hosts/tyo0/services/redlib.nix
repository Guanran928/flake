{ lib, ... }:
{
  services.redlib = {
    enable = true;
    address = "127.0.0.1";
    port = 9400;
  };

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton {
      host = [ "reddit.ny4.dev" ];
    };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = [ { dial = "localhost:9400"; } ];
    };
  };
}
