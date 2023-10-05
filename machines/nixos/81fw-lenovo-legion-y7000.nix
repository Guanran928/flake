{ lib, modulesPath, ... }:

{
  imports = [
    ./hardware/misc/audio.nix
    ./hardware/misc/bluetooth.nix
    ./hardware/misc/opengl.nix
    ./hardware/cpu/intel.nix
    ./hardware/gpu/intel.nix
    ./hardware/gpu/nvidia.nix
    ./hardware/gpu/nvidia-prime.nix
    ./hardware/accessories/xbox.nix
    (modulesPath + "/installer/scan/not-detected.nix") # what is this
  ];

  networking.hostName = "81fw-nixos";
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" ];
  services.fstrim.enable = true;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/6288ce7a-a153-4302-a4de-5dc71f58da79";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=@" ]; # nested subvol
    };
    #"/" = {
    #  device = "none";
    #  fsType = "tmpfs";
    #  options = [ "size=3G" "mode=755" ]; # mode=755 so only root can write to those files
    #};

    "/home" = {
      device = "/dev/disk/by-uuid/6288ce7a-a153-4302-a4de-5dc71f58da79";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=@home" ];
    };

    "/var/lib/flatpak" = {
      device = "/dev/disk/by-uuid/6288ce7a-a153-4302-a4de-5dc71f58da79";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=@flatpak" ];
    };

    "/btrfs" = {
      device = "/dev/disk/by-uuid/6288ce7a-a153-4302-a4de-5dc71f58da79";
      fsType = "btrfs";
      options = [ "compress=zstd" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/C44A-313A";
      fsType = "vfat";
    };
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/0ba792d3-571d-44bb-8696-82126611784d"; } ];



  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp7s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlan0.useDHCP = lib.mkDefault true;
}
