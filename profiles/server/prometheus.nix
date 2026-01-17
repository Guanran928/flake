{ config, lib, ... }:
let
  port = 9091;
in
{
  services.prometheus.exporters.node = {
    enable = true;
    listenAddress = "[::1]";
    inherit port;
    enabledCollectors = [ "systemd" ];
  };

  services.caddy.settings.apps.http.servers.srv0.metrics = { };
  services.caddy.settings.apps.http.servers.srv0.routes = [
    {
      match = lib.singleton {
        host = [ config.networking.fqdn ];
        path = [ "/metrics" ];
      };
      handle = [
        {
          handler = "authentication";
          providers.http_basic = {
            accounts = lib.singleton {
              username = "prometheus";
              password = "$2a$14$2Phk4tobM04H4XiGegB3TuEXkyORCKMKW8TptYPTPXUWmZgtGBj/.";
            };
            hash_cache = { };
          };
        }
        {
          handler = "reverse_proxy";
          upstreams = lib.singleton { dial = "[::1]:${toString port}"; };
        }
      ];
    }
  ];
}
