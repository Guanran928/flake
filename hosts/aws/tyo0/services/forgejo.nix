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

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "git.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "subroute";
      routes = [
        {
          match = lib.singleton { path = [ "/robots.txt" ]; };
          handle = lib.singleton {
            handler = "static_response";
            status_code = 200;
            body = ''
              User-agent: *
              Disallow: /
            '';
          };
        }
        {
          handle = lib.singleton {
            handler = "reverse_proxy";
            upstreams = [ { dial = "unix//run/forgejo/forgejo.sock"; } ];
          };
        }
      ];
    };
  };
}
