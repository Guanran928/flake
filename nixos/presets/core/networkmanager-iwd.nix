{ ... }:

{
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
    ethernet.macAddress = "random";
    wifi.macAddress = "random";
  };
}
