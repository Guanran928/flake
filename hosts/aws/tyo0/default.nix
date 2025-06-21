{
  lib,
  config,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    "${modulesPath}/virtualisation/amazon-image.nix"
    ./anti-feature.nix

    ./services/forgejo.nix
    ./services/grafana.nix
    ./services/keycloak.nix
    ./services/miniflux.nix
    ./services/murmur.nix
    ./services/ntfy.nix
    ./services/prometheus.nix
    ./services/vaultwarden.nix
    ./services/wastebin.nix

    ../../../nixos/profiles/sing-box-server
    ../../../nixos/profiles/restic
  ];

  _module.args.ports = import ./ports.nix;
  sops.defaultSopsFile = ./secrets.yaml;

  boot.loader.grub.device = lib.mkForce "/dev/nvme0n1";
  system.stateVersion = "24.05";

  swapDevices = lib.singleton {
    device = "/var/lib/swapfile";
    size = 4 * 1024; # 4 GiB
  };

  ### Services
  networking.firewall.allowedUDPPorts = [ 443 ];
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

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
            match = [ { "path" = [ "/*/olm.wasm" ]; } ];
            handle = lib.singleton {
              handler = "rewrite";
              uri = "/olm.wasm";
            };
          }
          {
            match = lib.singleton {
              not = [
                { path = [ "/index.html" ]; }
                { path = [ "/public/*" ]; }
                { path = [ "/assets/*" ]; }
                { path = [ "/config.json" ]; }
                { path = [ "/manifest.json" ]; }
                { path = [ "/pdf.worker.min.js" ]; }
                { path = [ "/olm.wasm" ]; }
              ];
              path = [ "/*" ];
            };
            handle = lib.singleton {
              handler = "rewrite";
              uri = "/index.html";
            };
          }
          {
            handle = lib.singleton {
              handler = "file_server";
              root = pkgs.cinny.override {
                conf = {
                  defaultHomeserver = 0;
                  homeserverList = [ "ny4.dev" ];
                };
              };
            };
          }
        ];
      };
    }
  ];

  services.postgresql = {
    package = pkgs.postgresql_16;
    settings = {
      max_connections = 200;
      shared_buffers = "256MB";
      effective_cache_size = "768MB";
      maintenance_work_mem = "64MB";
      checkpoint_completion_target = 0.9;
      wal_buffers = "7864kB";
      default_statistics_target = 100;
      random_page_cost = 1.1;
      effective_io_concurrency = 200;
      work_mem = "655kB";
      huge_pages = "off";
      min_wal_size = "1GB";
      max_wal_size = "4GB";
    };
    initialScript = pkgs.writeText "grafana-init.sql" ''
      CREATE ROLE "grafana" with LOGIN;
      CREATE DATABASE "grafana" WITH OWNER "grafana"
        TEMPLATE template0
        LC_COLLATE = "C"
        LC_CTYPE = "C";
    '';
  };
}
