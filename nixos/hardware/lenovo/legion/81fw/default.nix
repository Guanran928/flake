{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix") # what is this
  ];

  myFlake.nixos.hardware.components = {
    cpu.intel.enable = true;

    gpu.intel.enable = true;
    gpu.nvidia.enable = true;
    gpu.nvidia.prime = true;

    misc.audio.enable = true;
    misc.bluetooth.enable = true;
    misc.fstrim.enable = true;
    misc.tpm.enable = true;
  };

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid"];

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
