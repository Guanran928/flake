{
  lib,
  inputs,
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
      ExecStart = "${lib.getExe pkgs.swaybg} -i ${
        inputs.self.legacyPackages.${pkgs.stdenv.hostPlatform.system}.background
      } -m fill";
      Restart = "on-failure";
    };
  };

  # startup = [
  #   { command = lib.getExe config.programs.foot.package + " -e tmux"; }
  #   { command = lib.getExe config.programs.firefox.finalPackage; }
  #   { command = lib.getExe config.programs.thunderbird.package; }
  #   { command = lib.getExe pkgs.telegram-desktop; }
  # ];
  #
  #       "1:1:AT_Translated_Set_2_keyboard" = {
  #         xkb_layout = "us";
  #         xkb_options = "caps:escape,altwin:swap_lalt_lwin";
  #         xkb_variant = "dvorak";
  #       };
  #     };
  #
  #     assigns = {
  #       "1" = [ { app_id = "foot"; } ];
  #       "2" = [ { app_id = "firefox"; } ];
  #       "3" = [ { app_id = "org.telegram.desktop"; } ];
  #       "4" = [ { app_id = "thunderbird"; } ];
  #     };
  #
  #         # Launcher
}
