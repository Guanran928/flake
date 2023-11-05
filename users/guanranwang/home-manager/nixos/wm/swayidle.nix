{pkgs, ...}: {
  services = {
    swayidle = let
      lockCommand = "${pkgs.swaylock-effects}/bin/swaylock --screenshots --clock --indicator --line-color cdd6f4ff --text-color cdd6f4ff --inside-color 1e1e2eff --ring-color 313244ff --line-ver-color cdd6f4ff --text-ver-color cdd6f4ff --inside-ver-color 1e1e2eff --ring-ver-color 313244ff --line-clear-color cdd6f4ff --text-clear-color cdd6f4ff --inside-clear-color 1e1e2eff --ring-clear-color 313244ff --line-clear-color cdd6f4ff --text-wrong-color 313244ff --inside-wrong-color f38ba8ff --ring-wrong-color 313244ff --key-hl-color cba6f7ff --effect-blur 7x5 --effect-vignette 0.5:0.5 --fade-in 0.2";
    in {
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
          command = lockCommand;
        } # loginctl lock-session
        {
          event = "before-sleep";
          command = lockCommand;
        } # systemctl syspend
      ];
    };
  };
}
