{ config, lib, ... }:
{
  services.immich = {
    enable = true;
    settings = {
      server.externalDomain = "https://immich.ny4.dev";
      passwordLogin.enabled = false;
      oauth = {
        enabled = true;
        clientId = "8ce267c4-9fa1-4585-9d2b-bf4c7e6f7437";
        clientSecret = "NScJ8xx45TRkxsWgIeSxWXkQAyIfToOk";
        issuerUrl = "https://id.ny4.dev/.well-known/openid-configuration";
      };
    };
  };

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "immich.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "subroute";
      routes = lib.singleton {
        handle = lib.singleton {
          handler = "reverse_proxy";
          upstreams = [ { dial = "[::1]:${toString config.services.immich.port}"; } ];
        };
      };
    };
  };
}
