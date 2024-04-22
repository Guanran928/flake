{inputs, ...}: {
  imports = [
    inputs.nixpkgs.nixosModules.notDetected
    inputs.nixos-hardware.nixosModules.lenovo-legion-y530-15ich
    inputs.nixos-sensible.nixosModules.zram
  ];

  hardware.nvidia.nvidiaSettings = false;
  services.hdapsd.enable = false;
  myFlake.hardware.components = {
    audio.enable = true;
    bluetooth.enable = true;
    tpm.enable = true;
  };

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid"];
  boot.kernelModules = ["kvm-intel"];
  nixpkgs.hostPlatform = "x86_64-linux";
}
