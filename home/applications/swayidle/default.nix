{
  lib,
  config,
  ...
}:
{
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 60 * 10;
        command = "/run/current-system/sw/bin/systemctl suspend";
      }
    ];
    events = [
      {
        event = "lock";
        command = lib.getExe config.programs.swaylock.package;
      }
      {
        event = "before-sleep";
        command = "/run/current-system/systemd/bin/loginctl lock-session";
      }
    ];
  };
}
