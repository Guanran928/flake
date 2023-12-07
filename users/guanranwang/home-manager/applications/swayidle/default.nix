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
    displayOn = ''${pkgs.sway}/bin/swaymsg "output * power on"'';
    displayOff = ''${pkgs.sway}/bin/swaymsg "output * power off"'';
  in {
    enable = true;
    timeouts = [
      {
        timeout = 60 * 9;
        command = ''${pkgs.libnotify}/bin/notify-send -u critical --expire-time 60000 "60 seconds until lock!"'';
      }
      {
        timeout = 60 * 10;
        command = lock;
      } # lock screen
      {
        timeout = 60 * 20;
        command = displayOff;
        resumeCommand = displayOn;
      } # turn off screen
      {
        timeout = 60 * 30;
        command = "systemctl suspend";
      } # suspend
    ];
    events = [
      {
        event = "lock";
        command = lock;
      } # loginctl lock-session
      {
        event = "before-sleep";
        command = lock;
      } # systemctl suspend
    ];
  };
}
