{ inputs, pkgs, ... }:
{
  imports = [ inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-12th-gen ];

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  hardware.firmware = with pkgs; [
    linux-firmware
    alsa-firmware
    sof-firmware
  ];

  # https://www.phoronix.com/review/intel-mtl-i915-xe-linux
  hardware.intelgpu.driver = "xe";
  boot.kernelParams = [
    "i915.force_probe=!7d55"
    "xe.force_probe=7d55"
  ];

  services.fwupd.enable = true;
  services.fprintd.enable = true;

  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
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
