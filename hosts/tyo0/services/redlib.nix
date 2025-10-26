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
    address = "[::1]";
  };

  systemd.services.redlib.environment = {
    REDLIB_DEFAULT_USE_HLS = "on";
  };

  # Protect with anubis
  services.anubis.instances.redlib.settings.TARGET = "http://[::1]:${toString port}";

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "reddit.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = [ { dial = "unix/${config.services.anubis.instances.redlib.settings.BIND}"; } ];
    };
  };
}
