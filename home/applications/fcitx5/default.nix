{
  config,
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
      ++ (with inputs.berberman.packages.${pkgs.stdenv.hostPlatform.system}; [
        fcitx5-pinyin-moegirl
        fcitx5-pinyin-zhwiki
      ])
      ++ (with config.nur.repos.guanran928; [
        fcitx5-tokyonight
      ]);
  };

  xdg.configFile."fcitx5/conf/classicui.conf".text = ''
    Theme=Tokyonight-Storm
    Vertical Candidate List=True
    PreferTextIcon=True
  '';
  home.sessionVariables = {
    "FCITX_NO_PREEDIT_APPS" = "gvim.*,wps.*,wpp.*,et.*,cinny,epiphany";
  };
}
