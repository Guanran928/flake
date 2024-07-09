{inputs, ...}: {
  imports = [
    inputs.nixpkgs.nixosModules.notDetected
    inputs.nixos-hardware.nixosModules.lenovo-legion-y530-15ich
    inputs.nixos-sensible.nixosModules.zram
  ];

  services.hdapsd.enable = false;
  services.thermald.enable = true;

  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    settings.General.FastConnectable = true;
  };

  # nouveou
  services.xserver.videoDrivers = [];

  # novideo
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  # hardware.nvidia.nvidiaSettings = false;
  # environment.sessionVariables."MOZ_ENABLE_WAYLAND" = "0";
  # networking.networkmanager.enable = false;
  # services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # # https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/1562
  # services.udev.extraRules = ''
  #   ENV{DEVNAME}=="/dev/dri/card1", TAG+="mutter-device-preferred-primary"
  # '';

  boot.loader.timeout = 0;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid"];
  boot.kernelModules = ["kvm-intel"];
  nixpkgs.hostPlatform = "x86_64-linux";
}
