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
    ./ports.nix

    ./services/forgejo.nix
    ./services/keycloak.nix
    ./services/miniflux.nix
    ./services/murmur.nix
    ./services/ntfy.nix
    ./services/prometheus.nix
    ./services/vaultwarden.nix
    ./services/wastebin.nix

    ../../../nixos/profiles/sing-box-server
  ];

  boot.loader.grub.device = lib.mkForce "/dev/nvme0n1";
  system.stateVersion = "24.05";

  swapDevices = lib.singleton {
    device = "/var/lib/swapfile";
    size = 4 * 1024; # 4 GiB
  };

  # WORKAROUND:
  systemd.services."print-host-key".enable = false;

  # FIXME: error: builder for '/nix/store/...-ena-2.12.3-6.11.drv' failed with exit code 2
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_10;

  ### Secrets
  sops.secrets = lib.mapAttrs (_name: value: value // { sopsFile = ./secrets.yaml; }) {
    "prometheus/auth" = {
      owner = config.systemd.services.prometheus.serviceConfig.User;
      restartUnits = [ "prometheus.service" ];
    };
    "miniflux/environment" = {
      restartUnits = [ "miniflux.service" ];
    };
    "vaultwarden/environment" = {
      restartUnits = [ "vaultwarden.service" ];
    };
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
  };

  systemd.services."caddy".serviceConfig.SupplementaryGroups = [
    "forgejo"
    "ntfy-sh"
  ];

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
  };

  ### Prevents me from bankrupt
  # https://fmk.im/p/shutdown-aws/
  services.vnstat.enable = true;
  systemd.services."no-bankrupt" = {
    serviceConfig.Type = "oneshot";
    path = with pkgs; [
      coreutils
      gawk
      vnstat
      systemd
    ];
    script = ''
      TRAFF_TOTAL=1900
      TRAFF_USED=$(vnstat --oneline b | awk -F ';' '{print $11}')
      CHANGE_TO_GB=$(($TRAFF_USED / 1073741824))

      if [ $CHANGE_TO_GB -gt $TRAFF_TOTAL ]; then
          shutdown -h now
      fi
    '';
  };
  systemd.timers."no-bankrupt" = {
    timerConfig.OnCalendar = "*:0:0"; # Check every hour
  };
}
