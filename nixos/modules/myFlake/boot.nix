{
  config,
  lib,
  ...
}: let
  cfg = config.myFlake.boot;
in {
  options = {
    myFlake = {
      boot = {
        silentBoot = lib.mkEnableOption "Whether to enable silent boot.";
        noLoaderMenu = lib.mkEnableOption "Whether to disable bootloader menu.";
      };
    };
  };

  config = {
    ### cfg.noLoaderMenu
    boot.loader.timeout = lib.mkIf cfg.noLoaderMenu 0;

    ### cfg.silentBoot
    boot.consoleLogLevel = lib.mkIf cfg.silentBoot 0;
    boot.kernelParams =
      lib.mkIf cfg.silentBoot
      (["quiet"]
        ++ lib.optionals config.boot.initrd.systemd.enable [
          "systemd.show_status=auto"
          "rd.udev.log_level=3"
        ]);
  };
}
