{pkgs, ...}:
# no i dont actually own a server
{
  imports = [
    ../common/minimal
  ];

  boot.kernelPackages = pkgs.linuxPackages; # mkDefault for server
}
