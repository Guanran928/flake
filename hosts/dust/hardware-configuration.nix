{ inputs, ... }:
{
  imports = [
    inputs.nixpkgs.nixosModules.notDetected
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-12th-gen
  ];

  services.fwupd.enable = true;
  services.fprintd.enable = true;

  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    settings.General.FastConnectable = true;
  };

  networking.wireless.iwd.enable = true;

  boot.loader.timeout = 0;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
