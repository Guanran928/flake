{ pkgs, ... }:

{
  # Chinese IME
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      fcitx5-pinyin-moegirl # flakes
      fcitx5-pinyin-zhwiki
    ];
  };

  home.sessionVariables = {
    "FCITX_NO_PREEDIT_APPS" = "gvim.*,wps.*,wpp.*,et.*,cinny,epiphany";
    #GLFW_IM_MODULE = "ibus"; # IME support in kitty
    #GTK_IM_MODULE = "fcitx";
    #QT_IM_MODULE = "fcitx";
    #XMODIFIERS = "@im=fcitx";
  };
}