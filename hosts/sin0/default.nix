{ inputs, ... }:
{
  imports = [
    ./services/telegram-bot/danbooru_img_bot.nix
    ./services/telegram-bot/ny4_rdict_bot.nix

    ./services/bird-lg.nix
    ./services/caddy.nix
    ./services/chicken-box.nix
    ./services/dn42.nix
    ./services/ip-checker.nix
    ./services/nixpkgs-tracker.nix
    ./services/redlib.nix
    ./services/shortlinks.nix

    ../../profiles/sing-box-server

    inputs.self.nixosModules.dn42
  ];

  _module.args.ports = import ./ports.nix;
  sops.defaultSopsFile = ./secrets.yaml;
  system.stateVersion = "25.05";

  networking.firewall.enable = false;
}
