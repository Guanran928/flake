{
  lib,
  config,
  ...
}: let
  cfg = config.myFlake.nixos.hardware.accessories.xboxOneController;
in {
  options = {
    myFlake.nixos.hardware.accessories.xboxOneController.enable =
      lib.mkEnableOption "Whether to enable support for Xbox One controllers.";
  };

  # https://wiki.archlinux.org/title/Gamepad#Connect_Xbox_Wireless_Controller_with_Bluetooth
  config = lib.mkIf cfg.enable {
    hardware.xone.enable = true; # via Bluetooth
    hardware.xpadneo.enable = true; # via wired or wireless dongle
  };
}
