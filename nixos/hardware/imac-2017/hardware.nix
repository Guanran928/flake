{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    ../hardware/misc/audio.nix
    ../hardware/misc/bluetooth.nix
    ../hardware/misc/opengl.nix
    ../hardware/cpu/intel.nix
    ../hardware/gpu/amd.nix
    (modulesPath + "/hardware/network/broadcom-43xx.nix")
    (modulesPath + "/installer/scan/not-detected.nix") # what is this
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci"];

  # Options from github:NixOS/nixos-hardware
  boot.kernelParams = ["hid_apple.iso_layout=0"];
  hardware.facetimehd.enable = true; # TODO: Camera already works before adding this, not sure what is the point...

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0f0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;
}
