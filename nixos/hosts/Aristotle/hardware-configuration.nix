{
  modulesPath,
  inputs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.lenovo-legion-y530-15ich
  ];

  services.hdapsd.enable = false;
  myFlake.hardware.components = {
    audio.enable = true;
    bluetooth.enable = true;
    tpm.enable = true;
  };

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid"];
  boot.kernelModules = ["kvm-intel"];
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "23.11";
}
