{
  inputs,
  modulesPath,
  lib,
  ...
}:
{
  imports = [
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
  console = {
    earlySetup = true;
    keyMap = "dvorak";
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

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = lib.mkDefault [ "/dev/vda" ];
}
