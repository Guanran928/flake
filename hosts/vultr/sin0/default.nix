{ lib, config, ... }:
{
  imports = [
    ./anti-feature.nix

    ./services/telegram-bot/danbooru_img_bot.nix
    ./services/telegram-bot/ny4_rdict_bot.nix
    ./services/chicken-box.nix
    ./services/ip-checker.nix
    ./services/redlib.nix
    ./services/pixivfe.nix

    ../../../nixos/profiles/sing-box-server
  ];

  _module.args.ports = import ./ports.nix;

  system.stateVersion = "24.05";

  networking.firewall.allowedUDPPorts = [ 443 ];
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  sops.secrets = lib.mapAttrs (_n: v: v // { sopsFile = ./secrets.yaml; }) {
    "tg/danbooru_img_bot".restartUnits = [ "tg-danbooru_img_bot.service" ];
    "tg/ny4_rdict_bot".restartUnits = [ "tg-ny4_rdict_bot.service" ];
    "pixivfe/environment".restartUnits = [ "pixivfe.service" ];
  };

  systemd.services."caddy".serviceConfig.SupplementaryGroups = [ config.users.groups.anubis.name ];

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
}
