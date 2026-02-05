{
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    ../../profiles/sing-box
    ../../profiles/restic
    ./hardware-configuration.nix
  ]
  ++ (with inputs; [ nix-minecraft.nixosModules.minecraft-servers ])
  ++ (./services |> lib.fileset.fileFilter (file: file.hasExt "nix") |> lib.fileset.toList);

  _module.args.ports = import ./ports.nix;
  sops.defaultSopsFile = ./secrets.yaml;
  networking.hostName = "pek0";
  system.stateVersion = "25.11";

  # Password protected physical TTY access
  sops.secrets."hashed-passwd" = {
    neededForUsers = true;
  };
  users.users."root" = {
    hashedPasswordFile = config.sops.secrets."hashed-passwd".path;
  };
  boot = {
    kernelParams = [ "consoleblank=60" ];
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
}
