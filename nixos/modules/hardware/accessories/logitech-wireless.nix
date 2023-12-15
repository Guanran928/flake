{
  lib,
  config,
  ...
}: let
  cfg = config.myFlake.hardware.accessories.logitech-wireless;
in {
  options = {
    myFlake.hardware.accessories.logitech-wireless.enable =
      lib.mkEnableOption "Whether to enable support for wireless Logitech hardwares.";
  };

  config = lib.mkIf cfg.enable {
    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };
}
