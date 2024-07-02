{pkgs, ...}: {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      libsForQt5.fcitx5-chinese-addons
      fcitx5-pinyin-minecraft
      fcitx5-pinyin-moegirl
      fcitx5-pinyin-zhwiki
    ];
  };

  xdg.configFile."fcitx5/conf/classicui.conf".text = ''
    Vertical Candidate List=True
    PreferTextIcon=True
  '';
}
