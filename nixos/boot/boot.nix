{
  config,
  lib,
  ...
}: {
  options = {
    myFlake.nixos = {
      boot = {
        silentBoot = lib.mkEnableOption "Enable silent boot";
        noLoaderMenu = lib.mkEnableOption "Disable bootloader menu";
      };
    };
  };

  ### myFlake.nixos.boot.noLoaderMenu
  config.boot.loader.timeout = lib.mkIf config.myFlake.nixos.boot.noLoaderMenu 0;

  ### myFlake.nixos.boot.silentBoot
  config.boot.consoleLogLevel = lib.mkIf config.myFlake.nixos.boot.silentBoot 0;
  config.boot.kernelParams =
    lib.mkIf config.myFlake.nixos.boot.silentBoot
    (["quiet"]
      ++ lib.optionals config.boot.initrd.systemd.enable [
        "systemd.show_status=auto"
        "rd.udev.log_level=3"
      ]);

  ### Misc
  config.boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = lib.mkDefault true; # mkDefault for Lanzaboote
      editor = false; # Disabled for security
      ### Utilities
      #netbootxyz.enable = true;
      #memtest86.enable = true;
    };
  };
}
