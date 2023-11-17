{
  lib,
  config,
  ...
}: let
  cfg = config.myFlake.nixos.hardware.misc.fstrim;
in {
  options = {
    myFlake.nixos.hardware.misc.fstrim.enable = lib.mkEnableOption "Whether to enable SSD triming in background.";
  };

  config = lib.mkIf cfg.enable {
    services.fstrim.enable = true;
  };
}
