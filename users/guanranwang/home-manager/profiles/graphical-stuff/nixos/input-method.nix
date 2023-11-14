{pkgs, ...}: {
  # Chinese IME
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      fcitx5-pinyin-moegirl # Using Berberman's Flake overlay
      fcitx5-pinyin-zhwiki

      #fcitx5-rime
    ];
  };

  home.sessionVariables = {
    "FCITX_NO_PREEDIT_APPS" = "gvim.*,wps.*,wpp.*,et.*,cinny,epiphany";
  };
}
