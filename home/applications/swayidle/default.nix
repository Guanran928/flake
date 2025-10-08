{ lib, osConfig, ... }:
{
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 60 * 5;
        command = "/run/current-system/sw/bin/systemctl suspend";
      }
    ];
    events = [
      {
        event = "lock";
        command = lib.getExe osConfig.programs.gtklock.package;
      }
      {
        event = "before-sleep";
        command = "/run/current-system/systemd/bin/loginctl lock-session";
      }
    ];
  };
}
