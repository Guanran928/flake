{ lib, ports, ... }:
let
  port = ports.wastebin;
in
{
  services.wastebin = {
    enable = true;
    settings.WASTEBIN_ADDRESS_PORT = "[::1]:${toString port}";
  };

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "pb.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = [ { dial = "[::1]:${toString port}"; } ];
    };
  };
}
