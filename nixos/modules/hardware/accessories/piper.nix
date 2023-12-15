{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.myFlake.hardware.accessories.piper;
in {
  options = {
    myFlake.hardware.accessories.piper.enable =
      lib.mkEnableOption "Whether to enable Piper.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.piper];
    services.ratbagd.enable = true;
  };
}
