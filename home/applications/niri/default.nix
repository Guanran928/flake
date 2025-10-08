{
  lib,
  pkgs,
  ...
}:
{
  # remove csd window buttons
  # https://github.com/localsend/localsend/blob/2457acd8a7412723b174672d174e4853dccd7d99/app/linux/my_application.cc#L45
  home.sessionVariables.GTK_CSD = 0;
  dconf.settings."org/gnome/desktop/wm/preferences"."button-layout" = "appmenu:";

  home.packages = with pkgs; [
    niri
    brightnessctl
    playerctl
  ];

  xdg.configFile."niri/config.kdl".source = ./config.kdl;

  systemd.user.services.swaybg = {
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Unit = {
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.swaybg} -i ${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src} -m fill";
      Restart = "on-failure";
    };
  };
}
