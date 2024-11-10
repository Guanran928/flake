{ lib, ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "jellyfin.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "reverse_proxy";
      headers.request.set."X-Forwarded-Proto" = [ "https" ];
      upstreams = lib.singleton { dial = "127.0.0.1:8096"; };
    };
  };
}
