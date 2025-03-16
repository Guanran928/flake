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
    ../../nixos/profiles/restic

    # Hardware
    ./hardware-configuration.nix
    ./anti-feature.nix

    # Services
    ./services/jellyfin.nix
    ./services/mastodon.nix
    ./services/matrix.nix
    ./services/mautrix.nix
    ./services/minecraft.nix
    ./services/samba.nix
    ./services/transmission.nix
  ];

  _module.args.ports = import ./ports.nix;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  networking.hostName = "pek0";
  system.stateVersion = "24.05";

  # tty
  users.users."root".hashedPasswordFile = config.sops.secrets."hashed-passwd".path;
  boot.kernelParams = [ "consoleblank=60" ];
  console = {
    earlySetup = true;
    keyMap = "dvorak";
  };

  ######## Secrets
  sops.secrets = lib.mapAttrs (_name: value: value // { sopsFile = ./secrets.yaml; }) {
    "hashed-passwd" = {
      neededForUsers = true;
    };
    "synapse/secret" = {
      restartUnits = [ "matrix-synapse.service" ];
      owner = config.systemd.services.matrix-synapse.serviceConfig.User;
    };
    "synapse/oidc" = {
      restartUnits = [ "matrix-synapse.service" ];
      owner = config.systemd.services.matrix-synapse.serviceConfig.User;
    };
    "mautrix-telegram/environment" = {
      restartUnits = [ "mautrix-telegram.service" ];
    };
    "mastodon/environment" = {
      restartUnits = [ "mastodon-web.service" ];
    };
    "cloudflared/secret" = {
      restartUnits = [ "cloudflared-tunnel-b73805e7-a8a9-49db-8c9f-aae52c406635.service" ];
    };
  };

  networking = {
    useNetworkd = true;
    useDHCP = false;
  };

  systemd.network.networks.ethernet = {
    matchConfig.Name = [
      "en*"
      "eth*"
    ];
    DHCP = "yes";
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  services.cloudflared = {
    enable = true;
    tunnels."b73805e7-a8a9-49db-8c9f-aae52c406635" = {
      credentialsFile = config.sops.secrets."cloudflared/secret".path;
      default = "http_status:404";
      ingress = lib.genAttrs [ "jellyfin.ny4.dev" "mastodon.ny4.dev" "matrix.ny4.dev" "pek0.ny4.dev" ] (
        _: "http://localhost"
      );
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

  systemd.services."caddy".serviceConfig.SupplementaryGroups = [
    "mastodon"
    "matrix-synapse"
  ];

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
