{pkgs, ...}: {
  imports = [
    ./core.nix
    ../packages/graphical
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.plymouth.enable = true;
}
