{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    # OS
    ../../nixos/profiles/opt-in/mihomo
    ../../nixos/profiles/opt-in/wireless

    # Hardware
    ./hardware-configuration.nix
    ./anti-feature.nix
  ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  networking.hostName = "blacksteel";
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "23.11";

  services.openssh.settings.PermitRootLogin = "prohibit-password";

  ######## Secrets
  sops = {
    secrets = lib.mapAttrs (_name: value: value // {sopsFile = ./secrets.yaml;}) {
      "synapse/secret" = {
        restartUnits = ["matrix-synapse.service"];
        owner = config.systemd.services.matrix-synapse.serviceConfig.User;
      };
      "synapse/oidc" = {
        restartUnits = ["matrix-synapse.service"];
        owner = config.systemd.services.matrix-synapse.serviceConfig.User;
      };
      "syncv3/environment" = {
        restartUnits = ["matrix-sliding-sync.service"];
      };
      "mastodon/environment" = {
        restartUnits = ["mastodon-web.service"];
      };
      "cloudflared/secret" = {
        restartUnits = ["cloudflared-tunnel-6222a3e0-98da-4325-be19-0f86a7318a41.service"];
        owner = config.systemd.services."cloudflared-tunnel-6222a3e0-98da-4325-be19-0f86a7318a41".serviceConfig.User;
      };
    };
  };

  ######## Services
  environment.systemPackages = with pkgs; [qbittorrent];

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
        ingress = {
          # TODO: is this safe?
          # browser <-> cloudflare cdn <-> cloudflared <-> caddy <-> mastodon
          #                                             ^ no tls in this part?
          "mastodon.ny4.dev" = "http://localhost:80";
          "matrix.ny4.dev" = "http://localhost:80";
          "syncv3.ny4.dev" = "http://localhost:80";
        };
      };
    };
  };

  services.caddy = {
    enable = true;
    configFile = pkgs.substituteAll {
      src = ./Caddyfile;
      inherit (pkgs) mastodon;
    };
  };

  systemd.services.caddy.serviceConfig = {
    SupplementaryGroups = ["mastodon" "matrix-synapse"];
  };

  systemd.tmpfiles.settings = {
    "10-www" = {
      "/var/www/robots/robots.txt".C.argument = toString ../lightsail-tokyo/robots.txt;
    };
  };

  services.postgresql = {
    enable = true;
    settings = {
      # Generated by pgTune
      # https://pgtune.leopard.in.ua/#/
      #
      # DB Version: 15
      # OS Type: linux
      # DB Type: web
      # Total Memory (RAM): 16 GB
      # CPUs num: 8
      # Data Storage: ssd

      max_connections = 200;
      shared_buffers = "4GB";
      effective_cache_size = "12GB";
      maintenance_work_mem = "1GB";
      checkpoint_completion_target = 0.9;
      wal_buffers = "16MB";
      default_statistics_target = 100;
      random_page_cost = "1.1";
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

  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;

    package = pkgs.minecraftServers.vanilla-1-21;

    # Aikar's flag
    # https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/
    # https://docs.papermc.io/paper/aikars-flags
    jvmOpts = lib.concatStringsSep " " [
      "-Xms2G"
      "-Xmx2G"
      "-XX:+UseG1GC"
      "-XX:+ParallelRefProcEnabled"
      "-XX:MaxGCPauseMillis=200"
      "-XX:+UnlockExperimentalVMOptions"
      "-XX:+DisableExplicitGC"
      "-XX:+AlwaysPreTouch"
      "-XX:G1NewSizePercent=30"
      "-XX:G1MaxNewSizePercent=40"
      "-XX:G1HeapRegionSize=8M"
      "-XX:G1ReservePercent=20"
      "-XX:G1HeapWastePercent=5"
      "-XX:G1MixedGCCountTarget=4"
      "-XX:InitiatingHeapOccupancyPercent=15"
      "-XX:G1MixedGCLiveThresholdPercent=90"
      "-XX:G1RSetUpdatingPauseTimePercent=5"
      "-XX:SurvivorRatio=32"
      "-XX:+PerfDisableSharedMem"
      "-XX:MaxTenuringThreshold=1"
      "-Dusing.aikars.flags=https://mcflags.emc.gs"
      "-Daikars.new.flags=true"
    ];

    declarative = true;
    serverProperties = {
      motd = "NixOS Minecraft server!";
      white-list = true;

      difficulty = 3;
      gamemode = 0;
      max-players = 5;
    };
    whitelist = {
      "Guanran928" = "86dbb6c5-8d8b-4c45-b8eb-b3fdf03bfb27";
      "i_love_ravens" = "2788dd4b-b010-4a2f-9b5c-aad0c0e0cba5";
    };
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    shares = {
      "share" = {
        path = "/srv/samba/share";
        "read only" = "no";
      };
      "external" = {
        path = "/mnt";
        "read only" = "no";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  systemd.tmpfiles.rules = [
    "d /srv/samba/share 0755 guanranwang root"
  ];

  services.matrix-synapse = {
    enable = true;
    withJemalloc = true;
    enableRegistrationScript = false;
    extraConfigFiles = [config.sops.secrets."synapse/secret".path];
    settings = {
      server_name = "ny4.dev";
      public_baseurl = "https://matrix.ny4.dev";
      presence.enabled = false; # tradeoff
      listeners = [
        {
          path = "/run/matrix-synapse/synapse.sock";
          type = "http";
          resources = [
            {
              names = ["client" "federation"];
              compress = true;
            }
          ];
        }
      ];

      # https://element-hq.github.io/synapse/latest/openid.html#keycloak
      oidc_providers = [
        {
          idp_id = "keycloak";
          idp_name = "id.ny4.dev";
          issuer = "https://id.ny4.dev/realms/ny4";
          client_id = "synapse";
          client_secret_path = config.sops.secrets."synapse/oidc".path;
          scopes = ["openid" "profile"];
          user_mapping_provider.config = {
            localpart_template = "{{ user.preferred_username }}";
            display_name_template = "{{ user.name }}";
          };
          backchannel_logout_enabled = true;
          allow_existing_users = true;
        }
      ];
    };
  };

  systemd.services.matrix-synapse = {
    environment = config.networking.proxy.envVars;
    serviceConfig.RuntimeDirectory = ["matrix-synapse"];
  };

  services.matrix-sliding-sync = {
    enable = true;
    environmentFile = config.sops.secrets."syncv3/environment".path;
    settings = {
      SYNCV3_SERVER = "/run/matrix-synapse/synapse.sock";
      SYNCV3_BINDADDR = "/run/matrix-sliding-sync/sync.sock";
    };
  };

  systemd.services.matrix-sliding-sync.serviceConfig = {
    RuntimeDirectory = ["matrix-sliding-sync"];
    SupplementaryGroups = ["matrix-synapse"];
  };

  services.mastodon = {
    enable = true;
    localDomain = "ny4.dev";
    streamingProcesses = 1;
    mediaAutoRemove.olderThanDays = 14;
    # FIXME: this doesn't exist
    smtp = {
      createLocally = false;
      fromAddress = "mastodon@ny4.dev";
    };
    extraConfig = rec {
      SINGLE_USER_MODE = "true";
      WEB_DOMAIN = "mastodon.ny4.dev";

      # keycloak
      OMNIAUTH_ONLY = "true";
      OIDC_ENABLED = "true";
      OIDC_CLIENT_ID = "mastodon";
      # OIDC_CLIENT_SECRET # EnvironmentFile
      OIDC_DISCOVERY = "true";
      OIDC_DISPLAY_NAME = "id.ny4.dev";
      OIDC_ISSUER = "https://id.ny4.dev/realms/ny4";
      OIDC_REDIRECT_URI = "https://${WEB_DOMAIN}/auth/auth/openid_connect/callback";
      OIDC_SCOPE = "openid,profile,email";
      OIDC_SECURITY_ASSUME_EMAIL_IS_VERIFIED = "true";
      OIDC_UID_FIELD = "preferred_username";
    };
  };

  systemd.services.mastodon-web = {
    environment = config.networking.proxy.envVars;
    serviceConfig.EnvironmentFile = [config.sops.secrets."mastodon/environment".path];
  };

  systemd.services.mastodon-sidekiq-all.environment = config.networking.proxy.envVars;

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
}
