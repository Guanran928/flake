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

  gtk.font.name = "Sans";
  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      "titlebar-font" = "Sans Bold";
    };
    "org/gnome/desktop/interface" = {
      "document-font-name" = "Sans";
      "monospace-font-name" = "Monospace";
      # "font-name" is unneeded
      # https://github.com/nix-community/home-manager/blob/8765d4e38aa0be53cdeee26f7386173e6c65618d/modules/misc/gtk.nix#L237C19-L237C19
    };
  };
  xresources.properties = {
    # Fonts
    "Xft.autohint" = "0";
    "Xft.lcdfilter" = "lcddefault";
    "Xft.hintstyle" = "hintslight";
    "Xft.hinting" = "1";
    "Xft.antialias" = "1";
    "Xft.rgba" = "rgb";
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
