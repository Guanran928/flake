{ lib, config, ... }:
let
  port = config.lib.ports.redlib;
in
{
  services.redlib = {
    inherit port;
    enable = true;
    address = "127.0.0.1";
  };

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton {
      host = [ "reddit.ny4.dev" ];
    };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = [ { dial = "localhost:${toString port}"; } ];
    };
  };
}
