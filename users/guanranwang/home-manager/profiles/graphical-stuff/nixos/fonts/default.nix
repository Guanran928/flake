{pkgs, ...}: {
  fonts.fontconfig.enable = true;
  xdg.configFile = {
    "fontconfig" = {
      source = ./fontconfig;
      recursive = true;
    };
    "fontconfig/conf.d/web-ui-fonts.conf".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/lilydjwg/dotconfig/master/fontconfig/web-ui-fonts.conf";
      hash = "sha256-A4DcV6HTW/IRxXN3NaI1GUfoFdalwgFLpCjgbWENdZU=";
    };
    "fontconfig/conf.d/source-han-for-noto-cjk.conf".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/lilydjwg/dotconfig/master/fontconfig/source-han-for-noto-cjk.conf";
      hash = "sha256-jcdDr5VW1qZXbApgfT5FZgxonpRnLs9AY0QagfdL8ic=";
    };
  };

  home.packages = with pkgs; [
    ### Inter
    inter

    ### JetBrains Mono Nerd Font
    (nerdfonts.override {fonts = ["JetBrainsMono"];})

    ### Adobe Source Han
    source-han-sans
    source-han-serif
    source-han-mono

    ### Noto Fonts
    noto-fonts
    noto-fonts-color-emoji
  ];
}
