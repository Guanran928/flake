{ config, lib, ... }:
{
  services.pixivfe = {
    enable = true;
    openFirewall = true;
    settings.port = 8080;
    EnvironmentFile = config.sops.secrets."pixivfe/environment".path;
  };

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "pixiv.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = lib.singleton { dial = "127.0.0.1:8080"; };
    };
  };
}
