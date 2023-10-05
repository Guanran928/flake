{ lib, modulesPath, ... }:

{
  imports = [
    ./hardware/misc/audio.nix
    ./hardware/misc/bluetooth.nix
    ./hardware/misc/opengl.nix
    ./hardware/cpu/intel.nix
    ./hardware/gpu/amd.nix
    (modulesPath + "/hardware/network/broadcom-43xx.nix")
    (modulesPath + "/installer/scan/not-detected.nix") # what is this
  ];

  networking.hostName = "imac-nixos";

  # from nixos-hardware
  boot.kernelParams = [ "hid_apple.iso_layout=0" ];
  hardware.facetimehd.enable = true; # cam already works before adding this

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/67E3-17ED";
      fsType = "vfat";
    };

    "/" = {
      device = "/dev/disk/by-uuid/571588f1-dc9c-4804-a89c-995a667e0574";
      fsType = "ext4";
    };
  };

  boot.initrd.luks.devices."luks-998ea901-91c0-4c20-82f4-5dbcce1e1877".device = "/dev/disk/by-uuid/998ea901-91c0-4c20-82f4-5dbcce1e1877";

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0f0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;
}