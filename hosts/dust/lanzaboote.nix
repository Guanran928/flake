{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.sbctl ];
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
}
