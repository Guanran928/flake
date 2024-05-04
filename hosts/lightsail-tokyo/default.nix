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

  # WORKAROUND:
  systemd.services."print-host-key".enable = false;

  ### Secrets
  sops.secrets = builtins.mapAttrs (_name: value: value // {sopsFile = ./secrets.yaml;}) {
    "hysteria/auth".restartUnits = ["hysteria.service"];
    "searx/environment".restartUnits = ["searx.service"];
  };

  sops.templates."hysteria.yaml".content = ''
    tls:
      cert: /run/credentials/hysteria.service/cert
      key: /run/credentials/hysteria.service/key

    masquerade:
      type: proxy
      proxy:
        url: http://localhost/

    ${config.sops.placeholder."hysteria/auth"}
  '';

  ### Services
  networking.firewall.allowedUDPPorts = [443]; # h3 hysteria -> caddy
  networking.firewall.allowedTCPPorts = [80 443]; # caddy

  systemd.tmpfiles.settings = {
    "10-www" = {
      "/var/www/robots/robots.txt".C.argument = toString ./robots.txt;
    };
  };

  services.caddy = {
    enable = true;
    configFile = ./Caddyfile;
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

  # `journalctl -u murmur.service | grep Password`
  services.murmur = {
    enable = true;
    openFirewall = true;
    bandwidth = 128000;
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
      listen-http = "127.0.0.1:8400";
    };
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
