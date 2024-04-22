{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../common/core
    # ../common/minimal
    inputs.srvos.nixosModules.mixins-terminfo
  ];

  boot.kernelPackages = pkgs.linuxPackages;
  networking.wireless.iwd.enable = false;
}
