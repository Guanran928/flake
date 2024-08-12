{
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    "${modulesPath}/virtualisation/amazon-image.nix"
    ../../nixos/profiles/server
    ./anti-feature.nix

    ./services/forgejo.nix
    ./services/hysteria.nix
    ./services/keycloak.nix
    ./services/miniflux.nix
    ./services/murmur.nix
    ./services/ntfy.nix
    ./services/pixivfe.nix
    ./services/searx.nix
    ./services/vaultwarden.nix
  ];

  time.timeZone = "Asia/Tokyo";
  boot.loader.grub.device = lib.mkForce "/dev/nvme0n1";
  system.stateVersion = "24.05";

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 4 * 1024; # 4 GiB
    }
  ];

  # WORKAROUND:
  systemd.services."print-host-key".enable = false;

  ### Secrets
  sops.secrets = lib.mapAttrs (_name: value: value // {sopsFile = ./secrets.yaml;}) {
    "hysteria/auth" = {
      restartUnits = ["hysteria.service"];
    };
    "pixivfe/environment" = {
      restartUnits = ["pixivfe.service"];
    };
    "searx/environment" = {
      restartUnits = ["searx.service"];
    };
    "miniflux/environment" = {
      restartUnits = ["miniflux.service"];
    };
    "vaultwarden/environment" = {
      restartUnits = ["vaultwarden.service"];
    };
  };

  ### Services
  networking.firewall.allowedUDPPorts = [443]; # hysteria
  networking.firewall.allowedTCPPorts = [80 443]; # caddy

  systemd.tmpfiles.settings = {
    "10-www" = {
      "/var/www/robots/robots.txt".C.argument = toString ./robots.txt;
      "/var/www/matrix/client".C.argument = toString ./matrix-client.json;
      "/var/www/matrix/server".C.argument = toString ./matrix-server.json;
    };
  };

  services.caddy = {
    enable = true;
    configFile = pkgs.substituteAll {
      src = ./Caddyfile;

      "element" = pkgs.element-web.override {
        element-web-unwrapped = pkgs.element-web-unwrapped.overrideAttrs (oldAttrs: {
          version = "1.11.74-rc.0";
          src = oldAttrs.src.overrideAttrs {
            outputHash = "sha256-Dik4vBzybkb6Q7OgEDrQ3FBaUGOmUxr9SplyNm1JWZU=";
          };
          offlineCache = oldAttrs.offlineCache.overrideAttrs {
            outputHash = "sha256-+SSsFUVIVuNpy+CQT6+oFIGvzQLAHEokibXtxsidumQ=";
          };
        });

        conf.default_server_config."m.homeserver" = {
          base_url = "https://matrix.ny4.dev";
          server_name = "ny4.dev";
        };
      };

      "cinny" = pkgs.cinny.override {
        conf = {
          defaultHomeserver = 0;
          homeserverList = ["ny4.dev"];
        };
      };

      "mastodon" = pkgs.mastodon;
    };
  };

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

  services.wastebin = {
    enable = true;
    settings.WASTEBIN_ADDRESS_PORT = "127.0.0.1:8200";
  };

  services.uptime-kuma = {
    enable = true;
    settings.PORT = "8300";
  };

  services.redlib = {
    enable = true;
    address = "127.0.0.1";
    port = 9400;
  };

  ### Prevents me from bankrupt
  # https://fmk.im/p/shutdown-aws/
  services.vnstat.enable = true;
  systemd.services."no-bankrupt" = {
    serviceConfig.Type = "oneshot";
    path = with pkgs; [coreutils gawk vnstat systemd];
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
