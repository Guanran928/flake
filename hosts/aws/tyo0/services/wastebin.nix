{ lib, config, ... }:
let
  port = config.lib.ports.wastebin;
in
{
  services.wastebin = {
    enable = true;
    settings.WASTEBIN_ADDRESS_PORT = "127.0.0.1:${toString port}";
  };

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "pb.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = [ { dial = "localhost:${toString port}"; } ];
    };
  };
}
