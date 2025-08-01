{
  lib,
  config,
  ports,
  ...
}:
let
  port = ports.redlib;
in
{
  services.redlib = {
    inherit port;
    enable = true;
    address = "127.0.0.1";
  };

  systemd.services.redlib.environment = {
    REDLIB_DEFAULT_USE_HLS = "on";
  };

  # Protect with anubis
  services.anubis.instances.default.settings.TARGET = "http://localhost:${toString port}";

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "reddit.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = [ { dial = "unix/${config.services.anubis.instances.default.settings.BIND}"; } ];
    };
  };
}
