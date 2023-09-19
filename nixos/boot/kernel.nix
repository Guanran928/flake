{ pkgs, ... }:

{
  # NOTE: secureboot enabled in flake.nix
  boot = {
    #kernelPackages = pkgs.linuxPackages_latest; # latest kernel
    kernelPackages = pkgs.linuxPackages_zen; # zen kernel, often outdated
    #kernelPackages = pkgs.linuxKernel.Packages.linux_6_1;
  };
}
