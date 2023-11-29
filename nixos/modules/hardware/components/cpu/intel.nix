{
  lib,
  config,
  ...
}: let
  cfg = config.myFlake.nixos.hardware.components.cpu.intel;
in {
  options = {
    myFlake.nixos.hardware.components.cpu.intel.enable = lib.mkEnableOption "Whether to enable Intel CPU.";
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = ["kvm-intel"];
    hardware.cpu.intel.updateMicrocode = true;
    nixpkgs.hostPlatform = "x86_64-linux";
  };
}