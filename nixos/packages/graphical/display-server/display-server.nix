{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [ xterm ];
    displayManager = {
      startx.enable = true;
    };
    desktopManager = {
      #plasma5.enable = true;
    };
    windowManager = {
      #bspwm.enable = true;
    };
  };
}