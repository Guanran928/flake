{
  lib,
  config,
  inputs,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    "${modulesPath}/virtualisation/amazon-image.nix"
    ../../nixos/profiles/server
    ./anti-feature.nix
  ];

  time.timeZone = "Asia/Tokyo";
  boot.loader.grub.device = lib.mkForce "/dev/nvme0n1";
  system.stateVersion = "23.11";

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 4 * 1024; # 4 GiB
    }
  ];

  # WORKAROUND:
  systemd.services."print-host-key".enable = false;

  # FIXME:
  # error: 1 dependencies of derivation '/nix/store/h0wkpjfh0hr1vswyz2f7wk8n03yj0l81-linux-6.10-modules.drv' failed to build
  boot.kernelPackages = pkgs.linuxPackages;

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
          version = "1.11.70";
          src = oldAttrs.src.overrideAttrs {
            outputHash = "sha256-UzSqChCa94LqaQpMzwQGPX3G2xxOpP3jp5OvR1iBzRs=";
          };
          offlineCache = oldAttrs.offlineCache.overrideAttrs {
            outputHash = "sha256-M4FTUtx7vpZIEdu/NM98/zIDGyPOtfocrj29/qChyyQ=";
          };
        });

        conf.default_server_config."m.homeserver" = {
          base_url = "https://matrix.ny4.dev";
          server_name = "ny4.dev";
        };
      };

      "mastodon" = pkgs.mastodon;
    };
  };

  services.hysteria = {
    enable = true;
    settings = {
      auth = {
        type = "userpass";
        userpass = {
          _secret = "/run/credentials/hysteria.service/auth";
          quote = false;
        };
      };
      masquerade = {
        type = "proxy";
        proxy.url = "https://ny4.dev/";
      };
      tls = {
        cert = "/run/credentials/hysteria.service/cert";
        key = "/run/credentials/hysteria.service/key";
      };
    };
  };

  systemd.services."hysteria".serviceConfig.LoadCredential = [
    # FIXME: remove hardcoded path
    "auth:${config.sops.secrets."hysteria/auth".path}"
    "cert:/var/lib/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/tyo0.ny4.dev/tyo0.ny4.dev.crt"
    "key:/var/lib/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/tyo0.ny4.dev/tyo0.ny4.dev.key"
  ];

  # `journalctl -u murmur.service | grep Password`
  services.murmur = {
    enable = true;
    openFirewall = true;
    bandwidth = 256 * 1024; # 256 Kbit/s
  };

  services.searx = {
    enable = true;
    package = pkgs.searxng;
    environmentFile = config.sops.secrets."searx/environment".path;
    settings = {
      general.contact_url = "mailto:guanran928@outlook.com";
      search.autocomplete = "google";
      server = {
        port = 8100;
        secret_key = "@SEARX_SECRET@";
      };
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

  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://ntfy.ny4.dev";
      listen-http = "";
      listen-unix = "/run/ntfy-sh/ntfy.sock";
      listen-unix-mode = 511; # 0777
      behind-proxy = true;
    };
  };

  systemd.services.ntfy-sh.serviceConfig.RuntimeDirectory = ["ntfy-sh"];

  services.pixivfe = {
    enable = true;
    EnvironmentFile = config.sops.secrets."pixivfe/environment".path;
    settings = {
      PIXIVFE_UNIXSOCKET = "/run/pixivfe/pixiv.sock";
      PIXIVFE_IMAGEPROXY = "https://i.pixiv.re";
    };
  };

  systemd.services.pixivfe.serviceConfig = {
    RuntimeDirectory = ["pixivfe"];
    ExecStartPost = pkgs.writeShellScript "pixivfe-unixsocket" ''
      ${pkgs.coreutils}/bin/sleep 5
      ${pkgs.coreutils}/bin/chmod 777 /run/pixivfe/pixiv.sock
    '';
  };

  services.keycloak = {
    enable = true;
    settings = {
      cache = "local";
      hostname = "id.ny4.dev";
      http-host = "127.0.0.1";
      http-port = 8800;
      proxy = "edge";
      # proxy-headers = "xforwarded"; # FIXME: Key material not provided to setup HTTPS.
    };
    database.passwordFile = toString (pkgs.writeText "password" "keycloak");
  };

  # TODO: eventually, use blog homepage
  services.homepage-dashboard = {
    enable = true;
    listenPort = 9200;

    settings = {
      useEqualHeights = true;
      cardBlur = "sm";
      layout."Services" = {
        style = "row";
        columns = "4";
      };
    };

    services = let
      getDesc = pkg: pkg.meta.description;
      mapAttrsToList' = lib.mapAttrsToList (name: value: {"${name}" = value;}); # also sorts the thing alphabetically
    in
      mapAttrsToList' {
        "Services" = mapAttrsToList' {
          "Mumble" = {
            description = "${getDesc pkgs.mumble} (Connect with tyo0.ny4.dev:64738)";
          };
          "Ntfy" = {
            description = getDesc pkgs.ntfy;
            href = "https://ntfy.ny4.dev/";
          };
          "Redlib" = {
            description = getDesc pkgs.redlib;
            href = "https://reddit.ny4.dev/";
          };
          "SearXNG" = {
            description = getDesc pkgs.searxng;
            href = "https://searx.ny4.dev/";
          };
          "Wastebin" = {
            description = getDesc pkgs.wastebin;
            href = "https://pb.ny4.dev/";
          };
        };
        "Links" = mapAttrsToList' {
          "Blog".href = "https://blog.ny4.dev/";
          "Forgejo".href = "https://git.ny4.dev/nyancat";
          "GitHub".href = "https://github.com/Guanran928";
          "Mastodon".herf = "https://mastodon.ny4.dev/@nyancat";
          "Matrix".href = "https://matrix.to/#/@nyancat:ny4.dev";
        };
        "Private stuff" = mapAttrsToList' {
          "Forgejo" = {
            description = getDesc pkgs.forgejo;
            href = "https://git.ny4.dev/";
          };
          "Mastodon" = rec {
            description = getDesc pkgs.mastodon;
            href = "https://mastodon.ny4.dev/";
            widget.type = "mastodon";
            widget.url = href;
          };
          "Matrix" = {
            description = getDesc pkgs.element-web;
            href = "https://element.ny4.dev/";
          };
          "Miniflux" = {
            description = getDesc pkgs.miniflux;
            href = "https://rss.ny4.dev/";
          };
          "PixivFE" = {
            description = getDesc inputs.self.legacyPackages.${pkgs.stdenv.hostPlatform.system}.pixivfe;
            href = "https://pixiv.ny4.dev";
          };
          "Uptime Kuma" = {
            description = getDesc pkgs.uptime-kuma;
            href = "https://uptime.ny4.dev/";
          };
        };
      };
  };

  services.forgejo = {
    enable = true;
    database.type = "postgres";
    settings = {
      server = {
        DOMAIN = "git.ny4.dev";
        PROTOCOL = "http+unix";
        ROOT_URL = "https://git.ny4.dev/";
        SSH_DOMAIN = "tyo0.ny4.dev";
      };

      service = {
        ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
      };
    };
  };

  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.sops.secrets."miniflux/environment".path;
    config = {
      LISTEN_ADDR = "127.0.0.1:9300";
      BASE_URL = "https://rss.ny4.dev";

      OAUTH2_PROVIDER = "oidc";
      OAUTH2_CLIENT_ID = "miniflux";
      # OAUTH2_CLIENT_SECRET = "replace_me"; # EnvironmentFile
      OAUTH2_REDIRECT_URL = "https://rss.ny4.dev/oauth2/oidc/callback";
      OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://id.ny4.dev/realms/ny4";
    };
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
