{
  lib,
  config,
  ...
}: let
  cfg = config.myFlake.networking;
in {
  options = {
    myFlake = {
      networking = {
        network-configuration-daemon = lib.mkOption {
          type = lib.types.enum ["iwd" "networkmanager" "networkmanager-iwd"];
          default = "iwd";
          example = "networkmanager";
          description = "Select desired network configuration daemon.";
        };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.network-configuration-daemon == "iwd") {
      networking.wireless.iwd.enable = true;
    })
    (lib.mkIf (cfg.network-configuration-daemon == "networkmanager" || cfg.network-configuration-daemon == "networkmanager-iwd") {
      networking.networkmanager = {
        enable = true;
        ethernet.macAddress = "random";
        wifi.macAddress = "random";
      };
    })
    (lib.mkIf (cfg.network-configuration-daemon == "networkmanager-iwd") {
      networking.wireless.iwd.enable = true;
      networking.networkmanager.wifi.backend = "iwd";
    })
  ];
}
