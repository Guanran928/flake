{ ... }:

{
  networking = {
    wireless.iwd.enable = true;
    networkmanager.wifi.backend = "iwd";
  };
}