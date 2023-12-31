{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.myFlake.hardware.components.bluetooth;
in {
  options = {
    myFlake.hardware.components.bluetooth.enable = lib.mkEnableOption "Whether to enable bluetooth.";
  };

  # https://nixos.wiki/wiki/Bluetooth
  config = lib.mkIf cfg.enable {
    # Bluetooth manager
    #services.blueman.enable = true;
    environment.systemPackages = lib.mkIf config.services.xserver.enable (with pkgs; [blueberry]);

    # Bluetooth service
    hardware.bluetooth = {
      enable = true;
      settings.General.FastConnectable = true;
    };
  };
}
