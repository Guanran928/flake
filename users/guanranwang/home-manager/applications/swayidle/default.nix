{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../swaylock
  ];

  services = {
    swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 900;
          command = lib.getExe pkgs.swaylock-effects;
        } # lock screen
        {
          timeout = 905;
          command = "${pkgs.sway}/bin/swaymsg \"output * dpms off\"";
          resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * dpms on\"";
        } # turn off screen
        {
          timeout = 1200;
          command = ''systemctl suspend'';
        } # suspend
      ];
      events = [
        {
          event = "lock";
          command = lib.getExe pkgs.swaylock-effects;
        } # loginctl lock-session
        {
          event = "before-sleep";
          command = lib.getExe pkgs.swaylock-effects;
        } # systemctl syspend
      ];
    };
  };
}
