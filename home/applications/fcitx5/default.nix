{ lib, pkgs, ... }:
let
  package = pkgs.qt6Packages.fcitx5-with-addons.override {
    addons = with pkgs; [
      qt6Packages.fcitx5-chinese-addons
      fcitx5-pinyin-minecraft
      fcitx5-pinyin-moegirl
      fcitx5-pinyin-zhwiki
    ];
  };
in
{
  home.packages = [ package ];

  systemd.user.services.fcitx5-daemon = {
    Unit.Description = "Fcitx5 input method editor";
    Unit.PartOf = [ "graphical-session.target" ];
    Service.ExecStart = lib.getExe' package "fcitx5";
    Install.WantedBy = [ "graphical-session.target" ];
  };

  xdg.configFile."fcitx5/conf/classicui.conf".text = ''
    Vertical Candidate List=True
    PreferTextIcon=True
  '';
}
