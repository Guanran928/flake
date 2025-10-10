{ lib, ports, ... }:
let
  port = ports.bird-lg;
in
{
  services.bird-lg.frontend = {
    enable = true;
    listenAddresses = "[::1]:${toString port}";

    netSpecificMode = "dn42";
    whois = "whois.dn42";

    domain = "ny4.dev";
    proxyPort = 4200; # FIXME: this is hard-coded
    servers = [ "sin0" ];
  };

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "bird-lg.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "subroute";
      routes = lib.singleton {
        handle = lib.singleton {
          handler = "reverse_proxy";
          upstreams = [ { dial = "[::1]:${toString port}"; } ];
        };
      };
    };
  };
}
