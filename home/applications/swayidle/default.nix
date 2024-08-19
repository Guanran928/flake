{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ../swaylock
  ];

  services.swayidle = let
    lock = lib.getExe config.programs.swaylock.package;
    brightness = lib.getExe pkgs.brightnessctl;
  in {
    enable = true;
    timeouts = [
      {
        timeout = 60 * 9;
        command = "${brightness} -s set 20%";
        resumeCommand = "${brightness} -r";
      }
      {
        timeout = 60 * 10;
        command = "systemctl suspend";
      }
    ];
    events = [
      {
        event = "lock";
        command = lock;
      }
      {
        event = "before-sleep";
        command = lock;
      }
    ];
  };
}
