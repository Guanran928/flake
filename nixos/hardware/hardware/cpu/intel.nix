{...}: {
  boot.kernelModules = ["kvm-intel"];
  hardware.cpu.intel.updateMicrocode = true;
  nixpkgs.hostPlatform = "x86_64-linux";
}
