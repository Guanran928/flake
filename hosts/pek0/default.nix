{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    # OS
    ../../nixos/profiles/sing-box

    # Hardware
    ./hardware-configuration.nix
    ./anti-feature.nix

    # Services
    ./services/jellyfin.nix
    ./services/mastodon.nix
    ./services/matrix.nix
    ./services/minecraft.nix
    ./services/samba.nix
    ./services/transmission.nix
  ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  networking.hostName = "pek0";
  system.stateVersion = "24.05";

  ######## Secrets
  sops.secrets = lib.mapAttrs (_name: value: value // { sopsFile = ./secrets.yaml; }) {
    "synapse/secret" = {
      restartUnits = [ "matrix-synapse.service" ];
      owner = config.systemd.services.matrix-synapse.serviceConfig.User;
    };
    "synapse/oidc" = {
      restartUnits = [ "matrix-synapse.service" ];
      owner = config.systemd.services.matrix-synapse.serviceConfig.User;
    };
    "mastodon/environment" = {
      restartUnits = [ "mastodon-web.service" ];
    };
    "cloudflared/secret" = {
      restartUnits = [ "cloudflared-tunnel-6222a3e0-98da-4325-be19-0f86a7318a41.service" ];
      owner =
        config.systemd.services."cloudflared-tunnel-6222a3e0-98da-4325-be19-0f86a7318a41".serviceConfig.User;
    };
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  services.cloudflared = {
    enable = true;
    tunnels = {
      "6222a3e0-98da-4325-be19-0f86a7318a41" = {
        credentialsFile = config.sops.secrets."cloudflared/secret".path;
        default = "http_status:404";
        ingress = lib.genAttrs [
          "mastodon.ny4.dev"
          "matrix.ny4.dev"
          "pek0.ny4.dev"
        ] (_: "http://localhost");
      };
    };
  };

  services.caddy.enable = true;
  services.caddy.settings.apps.http.servers.srv0 = {
    listen = [ ":80" ];
    trusted_proxies = {
      ranges = [
        "192.168.0.0/16"
        "172.16.0.0/12"
        "10.0.0.0/8"
        "127.0.0.1/8"
        "fd00::/8"
        "::1"
      ];
      source = "static";
    };
    trusted_proxies_strict = 1;
  };

  systemd.services.caddy.serviceConfig = {
    SupplementaryGroups = [
      "mastodon"
      "matrix-synapse"
    ];
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    settings = {
      max_connections = 200;
      shared_buffers = "4GB";
      effective_cache_size = "12GB";
      maintenance_work_mem = "1GB";
      checkpoint_completion_target = 0.9;
      wal_buffers = "16MB";
      default_statistics_target = 100;
      random_page_cost = 1.1;
      effective_io_concurrency = 200;
      work_mem = "5242kB";
      huge_pages = "off";
      min_wal_size = "1GB";
      max_wal_size = "4GB";
      max_worker_processes = 8;
      max_parallel_workers_per_gather = 4;
      max_parallel_workers = 8;
      max_parallel_maintenance_workers = 4;
    };
    initialScript = pkgs.writeText "synapse-init.sql" ''
      CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
      CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
        TEMPLATE template0
        LC_COLLATE = "C"
        LC_CTYPE = "C";
    '';
  };

  services.postgresqlBackup = {
    enable = true;
    location = "/var/lib/backup/postgresql";
    compression = "zstd";
    startAt = "weekly";
  };
}
