{inputs, ...}: {
  imports = [
    inputs.nixpkgs.nixosModules.notDetected
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-12th-gen
  ];

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

  services.fprintd.enable = true;

  boot.loader.timeout = 0;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = ["ia32_emulation=0"];

  boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  nixpkgs.hostPlatform = "x86_64-linux";
}
