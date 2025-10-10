{
  lib,
  pkgs,
  config,
  ...
}:
{
  services.forgejo = {
    enable = true;
    package = pkgs.forgejo;
    database.type = "postgres";
    settings = {
      DEFAULT = {
        APP_NAME = "git.ny4.dev";
      };

      server = {
        DOMAIN = "git.ny4.dev";
        PROTOCOL = "http+unix";
        ROOT_URL = "https://git.ny4.dev/";
        SSH_DOMAIN = "sin0.ny4.dev";
        UNIX_SOCKET_PERMISSION = "660";
      };

      service = {
        ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
      };

      repository = {
        DISABLE_STARS = true;
        DEFAULT_BRANCH = "master";
      };
    };
  };

  # Protect with anubis
  services.anubis.instances.forgejo.settings.TARGET = "unix:///run/forgejo/forgejo.sock";
  systemd.services.anubis-forgejo.serviceConfig.SupplementaryGroups = [ "forgejo" ];

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "git.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "subroute";
      routes = lib.singleton {
        handle = lib.singleton {
          handler = "reverse_proxy";
          upstreams = [ { dial = "unix/${config.services.anubis.instances.forgejo.settings.BIND}"; } ];
        };
      };
    };
  };
}
