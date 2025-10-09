{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.caddy.enable = true;
  services.caddy.settings.apps.http.servers.srv0 = {
    listen = [ ":443" ];
    trusted_proxies = {
      # https://www.cloudflare.com/ips/
      ranges = [
        "173.245.48.0/20"
        "103.21.244.0/22"
        "103.22.200.0/22"
        "103.31.4.0/22"
        "141.101.64.0/18"
        "108.162.192.0/18"
        "190.93.240.0/20"
        "188.114.96.0/20"
        "197.234.240.0/22"
        "198.41.128.0/17"
        "162.158.0.0/15"
        "104.16.0.0/13"
        "104.24.0.0/14"
        "172.64.0.0/13"
        "131.0.72.0/22"

        "2400:cb00::/32"
        "2606:4700::/32"
        "2803:f800::/32"
        "2405:b500::/32"
        "2405:8100::/32"
        "2a06:98c0::/29"
        "2c0f:f248::/32"
      ];
      source = "static";
    };
    trusted_proxies_strict = 1;
  };

  systemd.services.caddy.serviceConfig.SupplementaryGroups = [ config.users.groups.anubis.name ];

  services.caddy.settings.apps.http.servers.srv0.routes = [
    {
      match = lib.singleton {
        host = [ "ny4.dev" ];
        path = [ "/.well-known/matrix/server" ];
      };
      handle = lib.singleton {
        handler = "static_response";
        status_code = 200;
        headers = {
          Access-Control-Allow-Origin = [ "*" ];
          Content-Type = [ "application/json" ];
        };
        body = builtins.toJSON { "m.server" = "matrix.ny4.dev:443"; };
      };
    }
    {
      match = lib.singleton {
        host = [ "ny4.dev" ];
        path = [ "/.well-known/matrix/client" ];
      };
      handle = lib.singleton {
        handler = "static_response";
        status_code = 200;
        headers = {
          Access-Control-Allow-Origin = [ "*" ];
          Content-Type = [ "application/json" ];
        };
        body = builtins.toJSON {
          "m.homeserver" = {
            "base_url" = "https://matrix.ny4.dev";
          };
        };
      };
    }
    {
      match = lib.singleton {
        host = [ "ny4.dev" ];
        path = [ "/.well-known/webfinger" ];
      };
      handle = lib.singleton {
        handler = "static_response";
        status_code = 301;
        headers = {
          Access-Control-Allow-Origin = [ "*" ];
          Location = [ "https://mastodon.ny4.dev{http.request.uri}" ];
        };
      };
    }
    {
      match = lib.singleton { host = [ "ny4.dev" ]; };
      handle = lib.singleton {
        handler = "static_response";
        status_code = 302;
        headers = {
          Location = [ "https://blog.ny4.dev" ];
        };
      };
    }
    {
      match = lib.singleton { host = [ "element.ny4.dev" ]; };
      handle = [
        {
          handler = "headers";
          response.set = {
            X-Frame-Options = [ "SAMEORIGIN" ];
            X-Content-Type-Options = [ "nosniff" ];
            X-XSS-Protection = [ "1; mode=block" ];
            Content-Security-Policy = [ "frame-ancestors 'self'" ];
          };
        }
        {
          handler = "file_server";
          root = pkgs.element-web.override {
            conf = {
              default_server_config."m.homeserver" = {
                base_url = "https://matrix.ny4.dev";
                server_name = "ny4.dev";
              };
              enable_presence_by_hs_url = {
                "https://matrix.ny4.dev" = false;
              };
            };
          };
        }
      ];
    }
    {
      match = lib.singleton { host = [ "cinny.ny4.dev" ]; };
      handle = lib.singleton {
        handler = "subroute";
        routes = [
          {
            handle = [
              {
                handler = "vars";
                root = pkgs.cinny.override {
                  conf = {
                    defaultHomeserver = 0;
                    homeserverList = [ "ny4.dev" ];
                  };
                };
              }
            ];
          }
          {
            match = [
              {
                file.try_files = [
                  "{http.request.uri.path}"
                  "/"
                  "index.html"
                ];
              }
            ];
            handle = [
              {
                handler = "rewrite";
                uri = "{http.matchers.file.relative}";
              }
            ];
          }
          { handle = lib.singleton { handler = "file_server"; }; }
        ];
      };
    }
  ];
}
