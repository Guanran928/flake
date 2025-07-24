{ lib, ... }:
{
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://ntfy.ny4.dev";
      listen-http = "";
      listen-unix = "/run/ntfy-sh/ntfy.sock";
      listen-unix-mode = 432; # 0660
      behind-proxy = true;
    };
  };

  systemd.services = {
    ntfy-sh.serviceConfig.RuntimeDirectory = [ "ntfy-sh" ];
    caddy.serviceConfig.SupplementaryGroups = [ "ntfy-sh" ];
  };

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "ntfy.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = [ { dial = "unix//run/ntfy-sh/ntfy.sock"; } ];
    };
  };
}
