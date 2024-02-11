{
  lib,
  config,
  ...
}: let
  cfg = config.myFlake.hardware.accessories.xboxOneController;
in {
  options = {
    myFlake.hardware.accessories.xboxOneController.enable =
      lib.mkEnableOption "Whether to enable support for Xbox One controllers.";
  };

  # https://wiki.archlinux.org/title/Gamepad#Connect_Xbox_Wireless_Controller_with_Bluetooth
  config = lib.mkIf cfg.enable {
    hardware.xone.enable = true; # via wired or wireless dongle
    hardware.xpadneo.enable = true; # via Bluetooth
  };
}
