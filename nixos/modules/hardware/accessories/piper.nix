{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.myFlake.nixos.hardware.accessories.piper;
in {
  options = {
    myFlake.nixos.hardware.accessories.piper.enable =
      lib.mkEnableOption "Whether to enable Piper.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.piper];
    services.ratbagd.enable = true;
  };
}
