{ lib, ... }:

{
  boot = {
    consoleLogLevel = lib.mkDefault 3;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = lib.mkDefault true; # mkDefault for Lanzaboote
        editor = false; # Disabled for security
        ### Utilities
        #netbootxyz.enable = true;
        #memtest86.enable = true;
      };
    };
  };
}
