{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.hardware.bluetooth;
in {
  options = {
    my.hardware.bluetooth.enable = lib.mkEnableOption "bluetooth";
  };

  # https://nixos.wiki/wiki/Bluetooth
  config = lib.mkIf cfg.enable {
    environment.systemPackages = lib.mkIf config.services.xserver.enable (with pkgs; [blueberry]);
    hardware.bluetooth = {
      enable = true;
      settings.General.FastConnectable = true;
    };
  };
}
