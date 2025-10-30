{ lib, pkgs, ... }:
let
  package = pkgs.qt6Packages.fcitx5-with-addons.override {
    addons = with pkgs; [
      fcitx5-fluent
      fcitx5-pinyin-minecraft
      fcitx5-pinyin-moegirl
      fcitx5-pinyin-zhwiki
      qt6Packages.fcitx5-chinese-addons
    ];
  };
in
{
  # NOTE: not using `i18n.inputMethod.fcitx5` to unset environment variables
  home.packages = [ package ];

  systemd.user.services.fcitx5-daemon = {
    Unit = {
      Description = "Fcitx5 input method editor";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service.ExecStart = lib.getExe' package "fcitx5";
    Install.WantedBy = [ "graphical-session.target" ];
  };

  xdg.configFile."fcitx5/conf/classicui.conf".text =
    # ini
    ''
      Vertical Candidate List=True
      PreferTextIcon=True
      Theme=FluentDark-solid
    '';
}
