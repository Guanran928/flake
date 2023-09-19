{ pkgs, ... }:

{
  # XDG portal
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ]; # disable if on gnome
  };
}