{ config, lib, ... }:
{
  services.immich = {
    enable = true;
    database.enableVectors = false;
    # TODO: expose the config
    environment.IMMICH_CONFIG_FILE = config.sops.secrets."immich/config".path;
  };

  sops.secrets."immich/config" = {
    owner = config.services.immich.user;
    restartUnits = [
      "immich-server.service"
      "immich-machine-learning.service"
    ];
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
