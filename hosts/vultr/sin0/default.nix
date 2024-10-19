{ lib, ... }:
{
  imports = [
    ./anti-feature.nix
    ./ports.nix

    ./services/telegram-bot/danbooru_img_bot.nix
    ./services/ip-checker.nix
    ./services/redlib.nix

    ../../../nixos/profiles/sing-box-server
  ];

  system.stateVersion = "24.05";

  networking.firewall.allowedUDPPorts = [ 443 ];
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  sops.secrets = lib.mapAttrs (_n: v: v // { sopsFile = ./secrets.yaml; }) {
    "tg/danbooru_img_bot" = { };
  };

  services.caddy.enable = true;
  services.caddy.settings.apps.http.servers.srv0 = {
    listen = [ ":443" ];
  };
}
