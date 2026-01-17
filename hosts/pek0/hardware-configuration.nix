{ inputs, ... }:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    apple-macbook-pro
    common-cpu-intel
    common-hidpi
    common-pc-laptop
    common-pc-laptop-ssd
  ];

  # keep-sorted start block=yes newline_separated=yes
  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    kernelModules = [ "kvm-intel" ];
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ab9b92a9-b67b-43b4-b0d9-9dd59ccd594b";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "compress-force=zstd"
      "noatime"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/E5DE-9C92";
    fsType = "vfat";
  };

  services = {
    thermald.enable = true;
  };
  # keep-sorted end
}
