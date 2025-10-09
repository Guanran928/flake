{
  lib,
  modulesPath,
  inputs,
  ...
}:
{
  imports = [
    "${modulesPath}/virtualisation/amazon-image.nix"

    ./services/bird-lg.nix
    ./services/caddy.nix
    ./services/dn42.nix
    ./services/forgejo.nix
    ./services/miniflux.nix
    ./services/murmur.nix
    ./services/ntfy.nix
    ./services/pocket-id.nix
    ./services/postgresql.nix
    ./services/prometheus.nix
    ./services/rustical.nix
    ./services/shortlinks.nix
    ./services/vaultwarden.nix
    ./services/wastebin.nix

    ./disko.nix
    ./preservation.nix

    ../../profiles/sing-box-server
    ../../profiles/restic

    inputs.disko.nixosModules.disko
    inputs.preservation.nixosModules.preservation
    inputs.self.nixosModules.dn42
  ];

  _module.args.ports = import ./ports.nix;
  sops.defaultSopsFile = ./secrets.yaml;
  system.stateVersion = "25.05";

  swapDevices = lib.singleton {
    device = "/var/lib/swapfile";
    size = 4 * 1024; # 4 GiB
  };

  networking = {
    firewall.enable = false;
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
}
