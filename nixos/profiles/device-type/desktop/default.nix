{pkgs, ...}: {
  imports = [
    ./graphical
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.plymouth.enable = true;
  networking.stevenblack.enable = true;
  services.system76-scheduler.enable = true;
  services.power-profiles-daemon.enable = true;
}
