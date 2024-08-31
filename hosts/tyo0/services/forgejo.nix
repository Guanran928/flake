{ lib, pkgs, ... }:
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
        SSH_DOMAIN = "tyo0.ny4.dev";
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

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton {
      host = [ "git.ny4.dev" ];
    };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = [ { dial = "unix//run/forgejo/forgejo.sock"; } ];
    };
  };
}
