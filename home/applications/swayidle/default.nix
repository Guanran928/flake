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
        command = "${brightness} set 75%-";
        resumeCommand = "${brightness} set 75%+";
      } # dim screen
      {
        timeout = 60 * 10;
        command = lock;
      } # lock screen
      {
        timeout = 60 * 20;
        command = ''${pkgs.sway}/bin/swaymsg "output * power off"'';
        resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * power on"'';
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
