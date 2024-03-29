{pkgs, ...}: {
  # WARN: I don't know fontconfig and I have no idea what am I doing. Please do not use as reference.
  xdg.configFile = {
    "fontconfig/fonts.conf".source = ./fonts.conf;

    "fontconfig/conf.d/10-web-ui-fonts.conf".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/lilydjwg/dotconfig/1b22d4f0740bb5bbd7c65b6c468920775171b207/fontconfig/web-ui-fonts.conf";
      hash = "sha256-A4DcV6HTW/IRxXN3NaI1GUfoFdalwgFLpCjgbWENdZU=";
    };
    "fontconfig/conf.d/10-source-han-for-noto-cjk.conf".source = pkgs.substitute {
      src = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/lilydjwg/dotconfig/1b22d4f0740bb5bbd7c65b6c468920775171b207/fontconfig/source-han-for-noto-cjk.conf";
        hash = "sha256-jcdDr5VW1qZXbApgfT5FZgxonpRnLs9AY0QagfdL8ic=";
      };
      substitutions = [
        "--replace-warn"
        "Source Han Sans"
        "Source Han Sans VF"
        "--replace-warn"
        "Source Han Serif"
        "Source Han Serif VF"
      ];
    };
    "fontconfig/conf.d/10-nerd-font-symbols.conf".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/${pkgs.nerdfonts.version}/10-nerd-font-symbols.conf";
      hash = "sha256-XwJMkcDtGlI+LFMrjCl/gicAnoBWnq3p9adrmieNZwU=";
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
  #
  # The reason I use Source Han instead of Noto CJK,
  # is because I heard from #archlinux-cn, Adobe packages font better.
  # You can 100% use noto-fonts-cjk-{sans,serif} if you prefer consistency/other reason.
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    inter
    jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
    source-han-sans-vf-otf
    source-han-serif-vf-otf
  ];
}
