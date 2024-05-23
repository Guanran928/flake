{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.nixpkgs.nixosModules.notDetected
    inputs.nixos-hardware.nixosModules.apple-macbook-pro
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    #inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.nixos-hardware.nixosModules.common-hidpi
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nixos-sensible.nixosModules.zram
  ];

  myFlake.hardware.components = {
    audio.enable = true;
    bluetooth.enable = true;
    tpm.enable = true;
  };

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.kernelModules = ["kvm-intel" "wl"];
  boot.extraModulePackages = [config.boot.kernelPackages.broadcom_sta];

  #hardware.nvidia.modesetting.enable = true;
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

  nixpkgs.hostPlatform = "x86_64-linux";

  # no disko because dual booting with macOS isnt very flexible
  boot.initrd.luks.devices."luks-8c26de19-f0d4-4ac7-a73c-a28dafd30544".device = "/dev/disk/by-uuid/8c26de19-f0d4-4ac7-a73c-a28dafd30544";
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/ab9b92a9-b67b-43b4-b0d9-9dd59ccd594b";
      fsType = "btrfs";
      options = ["subvol=@"];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/E5DE-9C92";
      fsType = "vfat";
    };
  };
  swapDevices = [
    {device = "/dev/disk/by-uuid/8a2e90a9-5cc2-40fc-82fe-69ef3cd88e29";}
  ];
}
