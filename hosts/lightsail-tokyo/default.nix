{
  modulesPath,
  lib,
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    "${modulesPath}/virtualisation/amazon-image.nix"
    inputs.nixos-sensible.nixosModules.zram
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

  ### Secrets
  sops = {
    secrets = builtins.mapAttrs (_name: value: value // {sopsFile = ./secrets.yaml;}) {
      "hysteria/auth" = {
        restartUnits = ["hysteria.service"];
      };
      "pixivfe/environment" = {
        restartUnits = ["pixivfe.service"];
      };
      "searx/environment" = {
        restartUnits = ["searx.service"];
      };
    };

    templates = {
      "hysteria.yaml".content = ''
        tls:
          cert: /run/credentials/hysteria.service/cert
          key: /run/credentials/hysteria.service/key

        masquerade:
          type: proxy
          proxy:
            url: https://ny4.dev/

        ${config.sops.placeholder."hysteria/auth"}
      '';
    };
  };

  ### Services
  networking.firewall.allowedUDPPorts = [
    # hysteria
    443
  ];
  networking.firewall.allowedTCPPorts = [
    # caddy
    80
    443

    # frp
    7000
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
    configFile = pkgs.substituteAll {
      src = ./Caddyfile;

      "element" = pkgs.element-web.override {
        conf.default_server_config."m.homeserver" = let
          inherit (config.services.matrix-synapse) settings;
        in {
          base_url = "https://matrix.ny4.dev";
          inherit (settings) server_name;
        };
      };

      "mastodon" = pkgs.mastodon;
    };
  };

  services.hysteria = {
    enable = true;
    configFile = config.sops.templates."hysteria.yaml".path;
    credentials = [
      # FIXME: remove hardcoded path
      "cert:/var/lib/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/ny4.dev/ny4.dev.crt"
      "key:/var/lib/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/ny4.dev/ny4.dev.key"
    ];
  };

  services.frp = {
    enable = true;
    role = "server";
    settings = {
      bindPort = 7000;
      auth.method = "token";
      auth.token = "p4$m93060THuwtYaF0Jnr(RvYGZkI*Lqvh!kGXNesZCm4JQubMQlFDzr#F7rAycE";
    };
  };

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
      http-host = "127.0.0.1";
      http-port = 8800;
      proxy = "edge";
      hostname-strict-backchannel = true;
      hostname = "id.ny4.dev";
      cache = "local";
    };
    database.passwordFile = toString (pkgs.writeText "password" "keycloak");
  };

  services.homepage-dashboard = {
    enable = true;
    listenPort = 9200;

    settings = {
      useEqualHeights = true;
      cardBlur = "sm";

      background = let
        # https://www.pixiv.net/en/artworks/49983419
        image = pkgs.fetchurl {
          url = "https://i.pximg.net/img-original/img/2015/04/23/12/43/35/49983419_p0.jpg";
          hash = "sha256-JZ5VmsjVjZfHXpx3JxzAyYzZppZmgH38AiAA+B0TDiw=";
          curlOptsList = ["-e" "https://www.pixiv.net/"];
        };
        # Crop 100px on top and bottom
        cropped = pkgs.runCommandNoCC "49983419_p0.jpg" {} ''
          ${lib.getExe pkgs.imagemagick} convert ${image} -crop 3500x1600+0+100 $out
        '';
      in "file://${cropped}";

      layout."Services" = {
        style = "row";
        columns = "4";
      };
    };

    services = [
      {
        "Services" = [
          {
            "SearXNG" = {
              description = "A privacy-respecting, open metasearch engine.";
              href = "https://searx.ny4.dev";
            };
          }
          {
            "Wastebin" = {
              description = "A minimal pastebin with a design shamelessly copied from bin.";
              href = "https://pb.ny4.dev";
            };
          }
          {
            "Ntfy" = {
              description = "Send push notifications to your phone or desktop using PUT/POST.";
              href = "https://ntfy.ny4.dev/";
            };
          }
          {
            "Mumble" = {
              description = "Open Source, Low Latency, High Quality Voice Chat. (Connect with ny4.dev:64738)";
            };
          }
        ];
      }
      {
        "Private stuff" = [
          {
            "Mastodon" = rec {
              description = "Free, open-source decentralized social media platform.";
              href = "https://mastodon.ny4.dev/";
              widget.type = "mastodon";
              widget.url = href;
            };
          }
          {
            "Matrix" = {
              description = "An open network for secure, decentralised communication.";
              href = "https://element.ny4.dev/";
            };
          }
          {
            "PixivFE" = {
              description = "A privacy respecting frontend for Pixiv.";
              href = "https://pixiv.ny4.dev";
            };
          }
          {
            "Uptime Kuma" = {
              description = "A fancy self-hosted monitoring tool.";
              href = "https://uptime.ny4.dev/";
            };
          }
        ];
      }
      {
        "Links" = [
          {"Blog".href = "https://blog.ny4.dev/";}
          {"GitHub".href = "https://github.com/Guanran928";}
          {"Mastodon".herf = "https://mastodon.ny4.dev/@nyancat";}
          {"Matrix".href = "https://matrix.to/#/@root:ny4.dev";}
        ];
      }
    ];
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
