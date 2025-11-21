{ pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        # keep-sorted start
        fcitx5-fluent
        fcitx5-pinyin-minecraft
        fcitx5-pinyin-moegirl
        fcitx5-pinyin-zhwiki
        qt6Packages.fcitx5-chinese-addons
        # keep-sorted end
      ];
    };
  };

  xdg.configFile."fcitx5/conf/classicui.conf".text =
    # ini
    ''
      Vertical Candidate List=True
      PreferTextIcon=True
      Theme=FluentDark-solid
    '';
}
