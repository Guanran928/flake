{pkgs, ...}: {
  imports = [
    ./swaylock.nix
  ];

  services = {
    swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 900;
          command = "loginctl lock-session";
        }
        {
          timeout = 905;
          command = ''${pkgs.sway}/bin/swaymsg "output * dpms off"'';
          resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * dpms on"'';
        } # turn off screen
      ];
      events = [
        {
          event = "lock";
          command = "swaylock";
        } # loginctl lock-session
        {
          event = "before-sleep";
          command = "swaylock";
        } # systemctl syspend
      ];
    };
  };
}
