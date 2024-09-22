{
  inputs,
  modulesPath,
  lib,
  ...
}:
{
  imports =
    [
      "${modulesPath}/installer/scan/not-detected.nix"
      "${modulesPath}/profiles/qemu-guest.nix"

      ./disko.nix
      ./preservation.nix

      ../../../nixos/profiles/restic
    ]
    ++ (with inputs; [
      disko.nixosModules.disko
      preservation.nixosModules.preservation
    ]);

  # vnc
  services.getty.autologinUser = "root";

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

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = lib.mkDefault [ "/dev/vda" ];
}
