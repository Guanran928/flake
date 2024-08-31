{ config, lib, ... }:
{
  services.prometheus.exporters.node = {
    enable = true;
    listenAddress = "127.0.0.1";
    port = 9091;
    enabledCollectors = [ "systemd" ];
  };

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton {
      host = [ config.networking.fqdn ];
      path = [ "/metrics" ];
    };
    handle = [
      {
        handler = "authentication";
        providers.http_basic.accounts = lib.singleton {
          username = "prometheus";
          password = "$2a$14$2Phk4tobM04H4XiGegB3TuEXkyORCKMKW8TptYPTPXUWmZgtGBj/.";
        };
      }
      {
        handler = "reverse_proxy";
        upstreams = lib.singleton { dial = "127.0.0.1:9091"; };
      }
    ];
  };
}
