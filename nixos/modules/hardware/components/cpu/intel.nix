{
  lib,
  config,
  ...
}: let
  cfg = config.myFlake.hardware.components.cpu.intel;
in {
  options = {
    myFlake.hardware.components.cpu.intel.enable = lib.mkEnableOption "Whether to enable Intel CPU.";
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = ["kvm-intel"];
    hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
