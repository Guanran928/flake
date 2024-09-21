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
    match = lib.singleton { host = [ "reddit.ny4.dev" ]; };
    handle = [
      {
        # Google's indexing caused a DoS with 800k requests...
        # https://developers.google.com/search/docs/crawling-indexing/block-indexing
        handler = "headers";
        response.set."X-Robots-Tag" = [ "noindex" ];
      }
      {
        handler = "reverse_proxy";
        upstreams = [ { dial = "localhost:${toString port}"; } ];
      }
    ];
  };
}
