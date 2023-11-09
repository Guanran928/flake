{
  lib,
  config,
  ...
}: let
  cfg = config.myFlake.nixos.networking.network-configuration-daemon;
in {
  options = {
    myFlake.nixos = {
      networking = {
        network-configuration-daemon = lib.mkOption {
          type = lib.types.enum ["iwd" "networkmanager" "networkmanager-iwd"];
          default = "iwd";
          example = "networkmanager";
          description = "Select network configuration daemon";
        };
      };
    };
  };

  config = {
    networking.wireless.iwd.enable = lib.mkIf (cfg == "iwd" || cfg == "networkmanager-iwd") true;

    networking.networkmanager = lib.mkIf (cfg == "networkmanager" || cfg == "networkmanager-iwd") {
      enable = true;
      ethernet.macAddress = "random";
      wifi.macAddress = "random";
      wifi.backend = lib.mkIf (cfg == "networkmanager-iwd") "iwd";
    };
  };
}
