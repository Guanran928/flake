{
  pkgs,
  inputs,
  ...
}: {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons =
      (with pkgs; [
        fcitx5-chinese-addons
        #fcitx5-rime
      ])
      ++ (with inputs.berberman.packages.${pkgs.system}; [
        fcitx5-pinyin-moegirl
        fcitx5-pinyin-zhwiki
      ]);
  };

  home.sessionVariables = {
    "FCITX_NO_PREEDIT_APPS" = "gvim.*,wps.*,wpp.*,et.*,cinny,epiphany";
  };
}
