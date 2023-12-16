{
  lib,
  modulesPath,
  inputs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.lenovo-legion-y530-15ich
  ];

  myFlake.hardware.components.misc = {
    audio.enable = true;
    bluetooth.enable = true;
    tpm.enable = true;
  };

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
