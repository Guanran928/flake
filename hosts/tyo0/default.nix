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
    ./services/keycloak.nix
    ./services/miniflux.nix
    ./services/murmur.nix
    ./services/ntfy.nix
    ./services/prometheus.nix
    ./services/redlib.nix
    ./services/sing-box.nix
    ./services/vaultwarden.nix
    ./services/wastebin.nix
  ];

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
  sops.secrets = lib.mapAttrs (_name: value: value // { sopsFile = ./secrets.yaml; }) {
    "sing-box/auth" = {
      restartUnits = [ "sing-box.service" ];
    };
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

  systemd.tmpfiles.settings = {
    "10-www" = {
      "/var/www/robots/robots.txt".C.argument = toString ./robots.txt;
      "/var/www/matrix/client".C.argument = toString ./matrix-client.json;
      "/var/www/matrix/server".C.argument = toString ./matrix-server.json;
    };
  };

  services.caddy = {
    enable = true;
    configFile = pkgs.replaceVars ./Caddyfile {
      "element" = pkgs.element-web.override {
        conf.default_server_config."m.homeserver" = {
          base_url = "https://matrix.ny4.dev";
          server_name = "ny4.dev";
        };
      };

      "cinny" = pkgs.cinny.override {
        conf = {
          defaultHomeserver = 0;
          homeserverList = [ "ny4.dev" ];
        };
      };
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
