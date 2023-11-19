{pkgs, ...}: {
  imports = [
    ../core

    ./power-management
    ./graphical
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.plymouth.enable = true;
  networking.stevenblack.enable = true;
}
