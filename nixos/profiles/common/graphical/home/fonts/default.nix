{pkgs, ...}: {
  # Fontconfig
  xdg.configFile = {
    "fontconfig/fonts.conf".source = ./fonts.conf;

    "fontconfig/conf.d/web-ui-fonts.conf".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/lilydjwg/dotconfig/1b22d4f0740bb5bbd7c65b6c468920775171b207/fontconfig/web-ui-fonts.conf";
      hash = "sha256-A4DcV6HTW/IRxXN3NaI1GUfoFdalwgFLpCjgbWENdZU=";
    };
    "fontconfig/conf.d/source-han-for-noto-cjk.conf".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/lilydjwg/dotconfig/1b22d4f0740bb5bbd7c65b6c468920775171b207/fontconfig/source-han-for-noto-cjk.conf";
      hash = "sha256-jcdDr5VW1qZXbApgfT5FZgxonpRnLs9AY0QagfdL8ic=";
    };
  };

  # Make GTK listen to fontconfig
  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      "titlebar-font" = "Sans Bold";
    };
    "org/gnome/desktop/interface" = {
      "font-name" = "Sans";
      "document-font-name" = "Sans";
      "monospace-font-name" = "Monospace";
    };
  };

  # HM managed fonts
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    ### Inter
    inter

    ### JetBrains Mono Nerd Font
    (nerdfonts.override {fonts = ["JetBrainsMono"];})

    ### Adobe Source Han
    # The reason I use Source Han instead of Noto CJK,
    # is because I heard from #archlinux-cn, Adobe packages font better.
    # You can 100% use noto-fonts-cjk-{sans,serif} if you prefer consistency/other reason.
    source-han-sans-vf-otf
    source-han-serif-vf-otf

    ### Noto Fonts
    noto-fonts
    noto-fonts-color-emoji
  ];
}
