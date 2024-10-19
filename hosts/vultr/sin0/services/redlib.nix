{ lib, ports, ... }:
let
  port = ports.redlib;
in
{
  services.redlib = {
    inherit port;
    enable = true;
    address = "127.0.0.1";
  };

  systemd.services."redlib".environment = {
    # Google's indexing caused a DoS with 800k requests...
    # https://developers.google.com/search/docs/crawling-indexing/block-indexing
    REDLIB_ROBOTS_DISABLE_INDEXING = "on";
    REDLIB_DEFAULT_USE_HLS = "on";
  };

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "reddit.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = [ { dial = "localhost:${toString port}"; } ];
    };
  };
}
