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

  # Fcitx5 themes
  xdg.configFile."fcitx5/conf/classicui.conf".text = "Theme=Tokyonight-Storm";
  xdg.dataFile = let
    tokyonight = pkgs.fetchFromGitHub {
      owner = "ch3n9w";
      repo = "fcitx5-Tokyonight";
      rev = "f7454ab387d6b071ee12ff7ee819f0c7030fdf2c";
      hash = "sha256-swOy0kDZUdqtC2sPSZEBLnHSs8dpQ/QfFMObI6BARfo=";
    };
  in {
    "fcitx5/themes/Tokyonight-Day".source = "${tokyonight}/Tokyonight-Day";
    "fcitx5/themes/Tokyonight-Storm".source = "${tokyonight}/Tokyonight-Storm";
  };

  home.sessionVariables = {
    "FCITX_NO_PREEDIT_APPS" = "gvim.*,wps.*,wpp.*,et.*,cinny,epiphany";
  };
}
