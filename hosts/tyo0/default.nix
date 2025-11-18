{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../modules/dn42.nix
    ../../profiles/sing-box-server
    ./hardware-configuration.nix

    # keep-sorted start
    ./services/bird-lg.nix
    ./services/caddy.nix
    ./services/chicken-box.nix
    ./services/dn42.nix
    ./services/ip-checker.nix
    ./services/nixpkgs-tracker.nix
    ./services/shortlinks.nix
    ./services/telegram-bot/danbooru_img_bot.nix
    ./services/telegram-bot/ny4_rdict_bot.nix
    # keep-sorted end
  ];

  _module.args.ports = import ./ports.nix;
  sops.defaultSopsFile = ./secrets.yaml;
  system.stateVersion = "25.05";

  networking.hostName = "tyo0";
  services.getty.autologinUser = "root";
}
