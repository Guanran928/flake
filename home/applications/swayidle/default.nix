{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  brightnessctl = lib.getExe pkgs.brightnessctl;
in
{
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = (60 * 5) - 30;
        command = toString (
          pkgs.writeScript "dim-screen"
            # bash
            ''
              current=$(${brightnessctl} get)
              max=$(${brightnessctl} max)
              low=$(($max / 10))

              if [ "$current" -gt "$low" ]; then
                  ${brightnessctl} --save set $low
              fi
            ''
        );
        resumeCommand = "${brightnessctl} --restore";
      }
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
