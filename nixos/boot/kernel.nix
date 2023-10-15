{ pkgs, ... }:

{
  boot = {
    #kernelPackages = pkgs.linuxPackages_latest;            # latest linux kernel
    kernelPackages = pkgs.linuxPackages_zen;                # latest linux-zen kernel
    #kernelPackages = pkgs.linuxKernel.Packages.linux_6_1;  # linux 6.1 LTS kernel
  };
}
