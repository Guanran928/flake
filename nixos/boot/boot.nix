{ lib, ... }:

{
  # NOTE: secureboot enabled in flake.nix
  boot = {
    consoleLogLevel = lib.mkDefault 3;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = lib.mkDefault true; # use lanzaboote instead for secureboot
        #netbootxyz.enable = true;
        #memtest86.enable = true;
      };
    };
  };
}
