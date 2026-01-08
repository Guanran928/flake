{
  lib,
  ports,
  inputs,
  ...
}:
let
  port = ports.bird-lg;
  endpoints =
    inputs.self.colmenaHive.deploymentConfig
    |> lib.filterAttrs (_name: host: lib.elem "dn42" host.tags)
    |> lib.attrNames;
in
{
  services.bird-lg.frontend = {
    enable = true;
    listenAddresses = "[::1]:${toString port}";

    netSpecificMode = "dn42";
    whois = "whois.dn42";

    domain = "ny4.dev";
    proxyPort = 4200; # FIXME: this is hard-coded
    servers = endpoints;
  };

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "bird-lg.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = [ { dial = "[::1]:${toString port}"; } ];
    };
  };
}
