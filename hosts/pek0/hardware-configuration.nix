{ inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.apple-macbook-pro
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-hidpi
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
  ];

  services.thermald.enable = true;
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/ab9b92a9-b67b-43b4-b0d9-9dd59ccd594b";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/E5DE-9C92";
      fsType = "vfat";
    };
  };

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.kernelModules = [
    "kvm-intel"
    "wl"
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
