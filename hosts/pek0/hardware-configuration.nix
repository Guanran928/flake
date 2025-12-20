{ inputs, ... }:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    apple-macbook-pro
    common-cpu-intel
    common-hidpi
    common-pc-laptop
    common-pc-laptop-ssd
  ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

  services.thermald.enable = true;
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/ab9b92a9-b67b-43b4-b0d9-9dd59ccd594b";
      fsType = "btrfs";
      options = [
        "subvol=@"
        "compress-force=zstd"
        "noatime"
      ];
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
