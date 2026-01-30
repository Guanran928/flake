{ inputs, pkgs, ... }:
{
  imports = [ inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-12th-gen ];

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    timeout = 0;
  };

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "thunderbolt"
      "nvme"
      "sd_mod"
    ];
    kernelModules = [ "kvm-intel" ];
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

  networking = {
    wireless.iwd.enable = true;
  };

  security = {
    rtkit.enable = true; # pipewire
  };

  services = {
    fprintd = {
      enable = true;
    };
    fwupd = {
      enable = true;
    };
    thermald = {
      enable = true;
      ignoreCpuidCheck = true;
    };
  };
}
