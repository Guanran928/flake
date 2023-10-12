{ lib, modulesPath, ... }:

{
  imports = [
    ../hardware/misc/audio.nix
    ../hardware/misc/bluetooth.nix
    ../hardware/misc/opengl.nix
    ../hardware/cpu/intel.nix
    ../hardware/gpu/intel.nix
    ../hardware/gpu/nvidia.nix
    ../hardware/gpu/nvidia-prime.nix
    (modulesPath + "/installer/scan/not-detected.nix") # what is this
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" ];
  services.fstrim.enable = true;

  # Nvidia PRIME
  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp7s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlan0.useDHCP = lib.mkDefault true;
}
